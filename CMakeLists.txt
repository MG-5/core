cmake_minimum_required(VERSION 3.0)
project(core VERSION 0.0.1 LANGUAGES CXX C)

set(TracealyzerSources "")
set(TracealyzerInludes "")

if (core_TRACEALYZER)
    list(APPEND TracealyzerSources 
        Tracealyzer/Src/SEGGER_RTT.c
        Tracealyzer/Src/trcKernelPort.c
        Tracealyzer/Src/trcSnapshotRecorder.c
        Tracealyzer/Src/trcStreamingPort.c
        Tracealyzer/Src/trcStreamingRecorder.c)
    list(APPEND TracealyzerInludes 
        Tracealyzer/Include)
endif()

add_library(${PROJECT_NAME} STATIC
    src/abi.cpp
    src/fault_handler.cpp
    src/hash.cpp
    src/SafeAssert.cpp
    src/std.cpp
    src/trace.cpp
    ${TracealyzerSources}
)

target_include_directories(${PROJECT_NAME} PUBLIC
    inc
    chip
    ${TracealyzerInludes}
)

# provide a static library containing freertos, named the same
# its target_include_directories need to be public as core is depending on them
target_link_libraries(${PROJECT_NAME} freertos)

# embedded / testing / fuzzing
if(core_BUILDCONFIGURATION STREQUAL "embedded")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDTYPE=2)
    message("You chose embedded build configuration.")
elseif(core_BUILDCONFIGURATION STREQUAL "testing")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDTYPE=3)
    message("You chose testing build configuration.")
elseif(core_BUILDCONFIGURATION STREQUAL "fuzzing")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDTYPE=4)
    message("You chose fuzzing build configuration.")
else()
    message(FATAL_ERROR "Please define a macro for your core_BUILDCONFIGURATION. You chose '${core_BUILDTYPE}'")
endif()

# release / debug
if (${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDCONFIG_DEBUG)
    message("Buildtype is DEBUG.")
elseif(${CMAKE_BUILD_TYPE} STREQUAL "Release")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDCONFIG_RELEASE)
    message("Buildtype is RELEASE.")
else()
    message(FATAL_ERROR "Please define a macro for your CMAKE_BUILD_TYPE. You chose '${CMAKE_BUILD_TYPE}' which is not implemented yet")
endif()

# tracealyzer support
if (core_TRACEALYZER)
    target_compile_definitions(${PROJECT_NAME} PUBLIC  OTTOCAR_TRACEALYZER_SUPPORT=1)
    message("You chose to enable tracealyzer support.")
else()
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_TRACEALYZER_SUPPORT=0)
    message("You chose NO tracealyzer support.")
endif()