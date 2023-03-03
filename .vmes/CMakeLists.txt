cmake_minimum_required(VERSION 3.20)
set(CMAKE_C_STANDARD 11)

project(vmes)
find_package(SDL2 REQUIRED)
include_directories(${SDL2_INCLUDE_DIRS})
include_directories(Virtual-MES/src)
set(VMES_SOURCES Virtual-MES/src/vmes.c Virtual-MES/src/gpu.c Virtual-MES/src/controller.c Virtual-MES/src/timer.c)

file(GLOB GAME_SOURCES "../src/*.c")
add_executable(game ${GAME_SOURCES} ${VMES_SOURCES})
target_link_libraries(game ${SDL2_LIBRARIES})
target_link_libraries(game m)