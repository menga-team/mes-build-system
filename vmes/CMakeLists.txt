cmake_minimum_required(VERSION 3.20)
set(CMAKE_C_STANDARD 11)

project(vmes)
find_package(SDL2 REQUIRED)
include_directories(${SDL2_INCLUDE_DIRS})
include_directories(../../.vmes/include)
set(VMES_SOURCES ../../.vmes/src/vmes.c ../../.vmes/src/gpu.c ../../.vmes/src/input.c ../../.vmes/src/timer.c ../../.vmes/src/rng.c ../../.vmes/src/data.c)

file(GLOB GAME_SOURCES "../../src/*.c")
add_executable(game ${GAME_SOURCES} ${VMES_SOURCES})
target_link_libraries(game ${SDL2_LIBRARIES})
target_link_libraries(game m)
