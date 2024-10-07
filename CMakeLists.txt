cmake_minimum_required(VERSION 3.22)
project(core VERSION 0.0.1 LANGUAGES CXX C ASM)

add_library(
    ${PROJECT_NAME} STATIC
    src/abi.cpp
    src/fault_handler.cpp
    src/std.cpp
)

target_include_directories(
    ${PROJECT_NAME} PUBLIC
    include
)

target_link_libraries(
    ${PROJECT_NAME}
    stm32cubemx
)
