# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(HarmonyNextDemo)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

# 新增cpp文件后，同样需要在 CMakeLists.txt 中添加对应cpp文件
add_library(library_napi SHARED napi_init.cpp  NativeEntry.cpp)
# 使用NDK 提供的C接口 需要在 CMakeLists.txt 中增加 libace_ndk.z.so 的引用
target_link_libraries(library_napi PUBLIC libace_napi.z.so libace_ndk.z.so)