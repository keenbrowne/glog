# - Nuget specific glog-config cmake file
#
# Copyright 2009 Kitware, Inc.
# Copyright 2009-2011 Philip Lowman <philip@yhbt.com>
# Copyright 2008 Esben Mose Hansen, Ange Optimization ApS
# Copyright Guillaume Dumont, 2014 [https://github.com/willyd]
# Copyright Bonsai AI, 2015 [http://bonsai.ai]
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#

if(NOT DEFINED glog_STATIC)
  # look for global setting
  if(NOT DEFINED BUILD_SHARED_LIBS OR BUILD_SHARED_LIBS)
    option (glog_STATIC "Link to static glog name" OFF)
  else()
    option (glog_STATIC "Link to static glog name" ON)
  endif()
endif()

# Determine architecture
if (CMAKE_CL_64)
  set (MSVC_ARCH x64)
else ()
  set (MSVC_ARCH Win32)
endif ()

# Determine VS version
# This build of Protobuf only works with MSVC 12.0 (Visual Studio 2013)
set (MSVC_VERSIONS 1800)
set (MSVC_TOOLSETS v120)

list (LENGTH MSVC_VERSIONS N_VERSIONS)
math (EXPR N_LOOP "${N_VERSIONS} - 1")

foreach (i RANGE ${N_LOOP})
  list (GET MSVC_VERSIONS ${i} _msvc_version)
  if (_msvc_version EQUAL MSVC_VERSION)
    list (GET MSVC_TOOLSETS ${i} MSVC_TOOLSET)
  endif ()
endforeach ()

if (NOT MSVC_TOOLSET)
  message( WARNING "Could not find binaries matching your compiler version. Defaulting to v120." )
  set( MSVC_TOOLSET v120 )
endif ()

get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

add_library(glog_static_lib STATIC IMPORTED)
set_target_properties(glog_static_lib PROPERTIES
  IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Debug/glog.lib
  IMPORTED_LOCATION_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Release/glog.lib
  IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
  )

add_library(glog_shared_lib SHARED IMPORTED)
set_target_properties(glog_shared_lib PROPERTIES 
  IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Debug/glog.dll
  IMPORTED_IMPLIB_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Debug/glog.lib
  IMPORTED_LOCATION_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Release/glog.dll
  IMPORTED_IMPLIB_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Release/glog.lib
  )

set(GLOG_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/build/native/include")
set(GLOG_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/build/native/include")

if (glog_STATIC)
    set (GLOG_LIBRARY glog_static_lib)
    set (GLOG_LIBRARIES glog_static_lib)
else ()
    set (GLOG_LIBRARY glog_shared_lib)
    set (GLOG_LIBRARIES glog_shared_lib)
endif()

# The following macro copies DLLs to output.
macro(glog_copy_shared_libs target)
    if (NOT glog_STATIC)
        add_custom_command( TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<$<CONFIG:Debug>:$<TARGET_PROPERTY:glog_shared_lib,IMPORTED_LOCATION_DEBUG>>
            $<$<NOT:$<CONFIG:Debug>>:$<TARGET_PROPERTY:glog_shared_lib,IMPORTED_LOCATION_RELEASE>>
            $<TARGET_FILE_DIR:${target}>
        )
    endif()
endmacro()

mark_as_advanced(GLOG_INCLUDE_DIR)

