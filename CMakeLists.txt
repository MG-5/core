cmake_minimum_required(VERSION 3.0)
project(core VERSION 0.0.1 LANGUAGES CXX C)


add_library(${PROJECT_NAME} STATIC
    src/abi.cpp
    src/fault_handler.cpp
    src/hash.cpp
    src/SafeAssert.cpp
    src/std.cpp
    src/trace.cpp
    FreeRTOS/src/croutine.c
    FreeRTOS/src/event_groups.c
    FreeRTOS/src/list.c
    FreeRTOS/src/queue.c
    FreeRTOS/src/stream_buffer.c
    FreeRTOS/src/tasks.c
    FreeRTOS/src/timers.c
)

target_include_directories(${PROJECT_NAME} PUBLIC
    inc
    chip
    ${FreeRTOS_ConfigPath}
    ${FreeRTOS_PortIncludePath}
    FreeRTOS/include
    FreeRTOS/include/FreeRTOS
)

# embedded / testing / fuzzing
if(core_BUILDCONFIGURATION STREQUAL "embedded")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_BUILDTYPE=2)
    message("You chose embedded build configuration.")
elseif(core_BUILDCONFIGURATION STREQUAL "testing")
    target_compile_definitions(${PROJECT_NAME} PUBLIC DOTTOCAR_BUILDTYPE=3)
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
if (core_TRACEALYZER STREQUAL "yes")
    target_compile_definitions(${PROJECT_NAME} PUBLIC  OTTOCAR_TRACEALYZER_SUPPORT=1)
    message("You chose to enable tracealyzer support.")
elseif(core_TRACEALYZER STREQUAL "no")
    target_compile_definitions(${PROJECT_NAME} PUBLIC OTTOCAR_TRACEALYZER_SUPPORT=0)
    message("You chose NO tracealyzer support.")
else()
    message(FATAL_ERROR "Please only define core_TRACEALYZER as 'yes' or 'no'")
endif()