cmake_minimum_required(VERSION 3.19)

project(
  pigz
  VERSION 2.7
  HOMEPAGE_URL "https://github.com/kjk/pigz"
  LANGUAGES C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED)

if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/zlib")
  message(STATUS "zlib 1")
  add_subdirectory(zlib EXCLUDE_FROM_ALL)
  add_library(ZLIB::ZLIB ALIAS zlibstatic)

  # fix for incorrect specification in upstream zlib
  target_include_directories(
    zlibstatic PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/zlib"
                      "${CMAKE_CURRENT_BINARY_DIR}/zlib")
else()
  message(STATUS "zlib 2")
  find_package(ZLIB REQUIRED)
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  if(IS_DIRECTORY pthread-win32)
    add_subdirectory(pthread-win32 EXCLUDE_FROM_ALL)
  else()
    find_package(pthread4w REQUIRED)
  endif()
endif()

if(IS_DIRECTORY zopfli)
  add_subdirectory(zopfli EXCLUDE_FROM_ALL)
else()
  find_package(Zopfli CONFIG REQUIRED)
endif()

find_package(Threads REQUIRED)

add_executable(pigz)

target_sources(
  pigz
  PRIVATE pigz.c
          try.c
          try.h
          yarn.c
          yarn.h
          $<$<C_COMPILER_ID:MSVC>:win32/dirent.c>
          $<$<C_COMPILER_ID:MSVC>:win32/dirent.h>
          $<$<C_COMPILER_ID:MSVC>:win32/wincompat.h>)

target_include_directories(
  pigz PRIVATE "${CMAKE_CURRENT_LIST_DIR}"
               "$<$<C_COMPILER_ID:MSVC>:${CMAKE_CURRENT_LIST_DIR}/win32>")

target_link_libraries(
  pigz PRIVATE Zopfli::libzopfli ZLIB::ZLIB
               $<$<C_COMPILER_ID:MSVC>:pthreads4w::pthreadVC3> Threads::Threads)

if(WIN32)
  add_custom_command(
    TARGET pigz
    POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_FILE:pigz>"
            "$<TARGET_FILE_DIR:pigz>/unpigz.exe"
    VERBATIM
    COMMENT "Create unpigz")
else()
  add_custom_command(
    TARGET pigz
    POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E create_symlink "$<TARGET_FILE_NAME:pigz>"
            "$<TARGET_FILE_DIR:pigz>/unpigz"
    VERBATIM
    COMMENT "Create unpigz")
endif()
