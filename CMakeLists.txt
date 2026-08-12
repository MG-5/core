cmake_minimum_required(VERSION 3.22)
project(core VERSION 0.0.1 LANGUAGES CXX C ASM)

add_library(
    ${PROJECT_NAME} STATIC
    src/abi.cpp
    src/fault_handler.cpp
    src/std.cpp
    RTT/RTT/SEGGER_RTT.c
    RTT/RTT/SEGGER_RTT_printf.c
)

target_include_directories(
    ${PROJECT_NAME} PUBLIC
    include
    RTT
    RTT/Config
)

target_link_libraries(
    ${PROJECT_NAME}
    stm32cubemx
)
