# fixes compiler detection with arm-none-eabi-gcc as cmake tries to
# build an executable but bare metal doesn't work like this
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR "In-source build detected! Generate cmake in an extra folder to avoid a mess of files generated in your folder")
endif()

if (${CMAKE_C_COMPILER} MATCHES "arm-none-eabi-")
    message("arm compiler detected")
    set(CMAKE_SYSTEM_NAME Generic)
    set(CMAKE_SYSTEM_PROCESSOR arm)

    # cmake and the programs orchestrating it are stupid sometimes and only detect the C compiler
    # using the same path, set CXX/objcopy/objdump paths explicitly
    # this of course breakes when you pull apart your compiler programs
    # but why would you do that?
    get_filename_component(CompilerPath "${CMAKE_C_COMPILER}" PATH)
    set(CMAKE_CXX_COMPILER ${CompilerPath}/arm-none-eabi-g++ CACHE INTERNAL "")
    set(CMAKE_OBJCOPY ${CompilerPath}/arm-none-eabi-objcopy CACHE INTERNAL "")
    set(CMAKE_OBJDUMP ${CompilerPath}/arm-none-eabi-objdump CACHE INTERNAL "")

    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

    set(isEmbeddedBuild true)
else()
    message("non-arm compiler detected")
    set(isEmbeddedBuild false)
endif()