cmake_minimum_required(VERSION 3.0)
project(core VERSION 0.0.1 LANGUAGES CXX C)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/detectCompilerType.cmake)
DETECT_COMPILER_TYPE()

# following target doesn't compile on non embedded builds
# exclusion is necessary for usage of "run all tests" cmake feature
# which forces everything to compile, even when unused
if (${isEmbeddedCompiler})
    add_library(tracealyzer
            Tracealyzer/Src/SEGGER_RTT.c
            Tracealyzer/Src/trcKernelPort.c
            Tracealyzer/Src/trcSnapshotRecorder.c
            Tracealyzer/Src/trcStreamingPort.c
            Tracealyzer/Src/trcStreamingRecorder.c
            src/trace.cpp
            )
    target_include_directories(tracealyzer PUBLIC
            Tracealyzer/Include
            )
    target_link_libraries(tracealyzer PUBLIC
            core freertos)
endif ()

# generate build information every time compile is started
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/include/core)
add_custom_target(generateVersionHeader
        ${PROJECT_SOURCE_DIR}/scripts/generateVersionHeader.py
        ${PROJECT_SOURCE_DIR}/../
        ${PROJECT_BINARY_DIR}/include/core/Version.h
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})

add_library(${PROJECT_NAME} STATIC
        src/abi.cpp
        src/fault_handler.cpp
        src/hash.cpp
        src/SafeAssert.cpp
        src/std.cpp
        )
target_include_directories(${PROJECT_NAME} PUBLIC
        inc
        chip
        ${PROJECT_BINARY_DIR}/include
        )
add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_EXPORTED_TARGETS} generateVersionHeader)

target_link_libraries(${PROJECT_NAME} freertos hal_headers)

# embedded / testing / fuzzing / emulator
if (core_BUILDCONFIGURATION STREQUAL "embedded")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDTYPE=2)
    message("You chose embedded build configuration.")
elseif (core_BUILDCONFIGURATION STREQUAL "testing")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDTYPE=3)
    message("You chose testing build configuration.")
elseif (core_BUILDCONFIGURATION STREQUAL "fuzzing")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDTYPE=4)
    message("You chose fuzzing build configuration.")
elseif (core_BUILDCONFIGURATION STREQUAL "emulator")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDTYPE=5)
    message("You chose emulator build configuration.")
else ()
    message(FATAL_ERROR "Please define a macro for your core_BUILDCONFIGURATION. You chose '${core_BUILDTYPE}'")
endif ()

# release / debug
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDCONFIG_DEBUG)
    message("Buildtype is DEBUG.")
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDCONFIG_RELEASE)
    message("Buildtype is RELEASE.")
else ()
    message(FATAL_ERROR "Please define a macro for your CMAKE_BUILD_TYPE. You chose '${CMAKE_BUILD_TYPE}' which is not implemented yet. Did you forget to add -DCMAKE_BUILD_TYPE=Release or -DCMAKE_BUILD_TYPE=Debug?")
endif ()