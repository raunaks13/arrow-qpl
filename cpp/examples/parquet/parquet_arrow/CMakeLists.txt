# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Require cmake that supports BYPRODUCTS in add_custom_command, ExternalProject_Add [1].
include(CMakePrintHelpers)

cmake_minimum_required(VERSION 3.16)

project(parquet_arrow_example)

include(ExternalProject)
include(FindPkgConfig)
include(GNUInstallDirs)

set(CMAKE_BUILD_TYPE Debug)
# set(CMAKE_PREFIX_PATH /home/raunaks3/dist/)
SET(CMAKE_PREFIX_PATH "/home/raunaks3/dist/;/home/raunaks3/qpl_library/")
# cmake_print_variables(CMAKE_PREFIX_PATH)

foreach(path ${CMAKE_PREFIX_PATH})
  message("Path: " ${path})
endforeach(path)

option(PARQUET_LINK_SHARED "Link to the Parquet shared library" ON)

# This ensures that things like -std=gnu++... get passed correctly
if(NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()

# We require a C++17 compliant compiler
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Look for installed packages the system
find_package(Parquet REQUIRED)
find_package(QPL CONFIG REQUIRED)

add_executable(parquet-arrow-example reader_writer.cc)

add_executable(qpl-filter-testing read_tpch.cc)


target_link_libraries(parquet-arrow-example QPL::qpl)

if(PARQUET_LINK_SHARED)
  target_link_libraries(parquet-arrow-example Parquet::parquet_shared)
else()
  target_link_libraries(parquet-arrow-example Parquet::parquet_static)
endif()

target_link_libraries(qpl-filter-testing QPL::qpl)

if(PARQUET_LINK_SHARED)
  target_link_libraries(qpl-filter-testing Parquet::parquet_shared)
else()
  target_link_libraries(qpl-filter-testing Parquet::parquet_static)
endif()
