cmake_minimum_required(VERSION 3.22)
project(core VERSION 0.0.1 LANGUAGES CXX C ASM)

include(${CMAKE_CURRENT_LIST_DIR}/detectCompilerType.cmake)
DETECT_COMPILER_TYPE()

add_library(
    ${PROJECT_NAME} STATIC
    src/abi.cpp
    src/fault_handler.cpp
    src/SafeAssert.cpp
    src/std.cpp
)

target_include_directories(
    ${PROJECT_NAME} PUBLIC
    inc
)

target_link_libraries(
    ${PROJECT_NAME}
    stm32cubemx
)

# embedded / testing / fuzzing / emulator
if (NOT DEFINED core_BUILDCONFIGURATION)
    message(FATAL_ERROR "Required variable core_BUILDCONFIGURATION is not defined. \
    Use set(core_BUILDCONFIGURATION <embedded|testing|fuzzing|emulator>) in your CMakeLists.txt file.")
endif()
if (core_BUILDCONFIGURATION STREQUAL "embedded")
    target_compile_definitions(${PROJECT_NAME} PUBLIC BUILDTYPE=2)
    message("You choose embedded build configuration.")
elseif (core_BUILDCONFIGURATION STREQUAL "testing")
    target_compile_definitions(${PROJECT_NAME} PUBLIC BUILDTYPE=3)
    message("You choose testing build configuration.")
elseif (core_BUILDCONFIGURATION STREQUAL "fuzzing")
    target_compile_definitions(${PROJECT_NAME} PUBLIC BUILDTYPE=4)
    message("You choose fuzzing build configuration.")
elseif (core_BUILDCONFIGURATION STREQUAL "emulator")
    target_compile_definitions(${PROJECT_NAME} PUBLIC BUILDTYPE=5)
    message("You choose emulator build configuration.")
else ()
    message(FATAL_ERROR "Please define a macro for your core_BUILDCONFIGURATION. You choose '${core_BUILDTYPE}'")
endif ()

if (NOT DEFINED isEmbeddedCompiler)
    message(FATAL_ERROR "Required variable isEmbeddedCompiler is not in scope")
endif ()

if (NOT ${isEmbeddedCompiler})
    include(CTest)
    find_package(PkgConfig)
    pkg_search_module(GTEST REQUIRED gtest)
    pkg_search_module(GMOCK REQUIRED gmock)

    add_executable(${PROJECT_NAME}_test
            tests/src/main.cpp
            tests/src/SafeAssertTest.cpp
            )
    target_include_directories(${PROJECT_NAME}_test PRIVATE
            tests/include)
    target_link_libraries(${PROJECT_NAME}_test PRIVATE
            ${GTEST_LDFLAGS}
            ${GMOCK_LDFLAGS}
            gcov
            ${PROJECT_NAME})
    target_link_options(${PROJECT_NAME}_test PRIVATE --coverage)
    target_compile_options(${PROJECT_NAME}_test PRIVATE ${GTEST_CFLAGS} ${GMOCK_CFLAGS} --coverage)
    add_test(${PROJECT_NAME} ${PROJECT_NAME}_test)
endif ()
