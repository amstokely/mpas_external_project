cmake_minimum_required(VERSION 3.20)
project(mpas_external_project LANGUAGES CXX C Fortran)
include(ExternalProject)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

find_package(PnetCDF REQUIRED)
set(PNETCDF ${PnetCDF_PREFIX})

find_program(MAKE_EXE NAMES gmake nmake make)

set(MPAS_TARGET gnu)
set(MPAS_SHAREDLIB false)
set(MPAS_DEBUG false)
set(MPAS_CORE atmosphere)
set(MPAS_NJOBS 4)

set(MPAS_ROOT_DIR ${CMAKE_SOURCE_DIR}/MPAS)
set(MPAS_CORE_EXE "atmosphere_model")

ExternalProject_Add(mpas
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/MPAS
        GIT_REPOSITORY https://github.com/MPAS-Dev/MPAS-Model
        GIT_TAG develop
        BUILD_IN_SOURCE TRUE
        CONFIGURE_COMMAND ""
        BUILD_COMMAND
        ${CMAKE_COMMAND} -E env PNETCDF=${PNETCDF}
        ${MAKE_EXE} -j${MPAS_NJOBS} ${MPAS_TARGET}
        CORE=${MPAS_CORE}
        SHAREDLIB=${MPAS_SHAREDLIB}
        DEBUG=${MPAS_DEBUG}
)

file(GLOB_RECURSE MPAS_MOD_FILES
        CONFIGURE_DEPENDS
        ${MPAS_ROOT_DIR}/src/*.mod
)

ExternalProject_Add_Step(mpas copy_mods
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/mod
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${MPAS_MOD_FILES} ${CMAKE_BINARY_DIR}/mod
        DEPENDEES build
)

file(GLOB_RECURSE MPAS_LIB_FILES
        CONFIGURE_DEPENDS
        ${MPAS_ROOT_DIR}/src/*.a
)

ExternalProject_Add_Step(mpas copy_libs
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/lib
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${MPAS_LIB_FILES} ${CMAKE_BINARY_DIR}/lib
        DEPENDEES copy_mods
)

file(GLOB_RECURSE MPAS_CORE_EXE
        CONFIGURE_DEPENDS
        ${MPAS_ROOT_DIR}/${MPAS_CORE_EXE}
)

ExternalProject_Add_Step(mpas copy_core_exe
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/bin
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${MPAS_CORE_EXE} ${CMAKE_BINARY_DIR}/bin
        DEPENDEES copy_libs
)

add_library(MPAS::mpas INTERFACE IMPORTED GLOBAL)

file(GLOB MPAS_LIBS
        ${CMAKE_BINARY_DIR}/lib/*.a)

set_target_properties(MPAS::mpas PROPERTIES
        INTERFACE_LINK_LIBRARIES "${MPAS_LIBS}"
        INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_BINARY_DIR}/mod"
)

add_dependencies(MPAS::mpas mpas)
