cmake_minimum_required(VERSION 3.8)
project(arch_task1)

set(CMAKE_C_STANDARD 99)

set(SOURCE_FILES bignum_stack.c)
add_executable(arch_task1 ${SOURCE_FILES})