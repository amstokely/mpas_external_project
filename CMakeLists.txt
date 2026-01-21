cmake_minimum_required(VERSION 3.20)
project(mpas_external_project LANGUAGES CXX C Fortran)
include(ExternalProject)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

find_package(MPI REQUIRED COMPONENTS Fortran C)
find_package(PnetCDF REQUIRED COMPONENTS Fortran C)

find_program(MAKE_EXE NAMES gmake nmake make)

set(MPAS_TARGET gnu)
set(MPAS_SHAREDLIB true)
set(MPAS_DEBUG false)
set(MPAS_CORE atmosphere)
set(MPAS_NJOBS 4)

set(MPAS_ROOT_DIR ${CMAKE_SOURCE_DIR}/MPAS)
set(MPAS_CORE_EXE "atmosphere_model")

ExternalProject_Add(mpas
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/MPAS
        GIT_REPOSITORY https://github.com/amstokely/MPAS-Model
        GIT_TAG libmpas_subdriver
        BUILD_IN_SOURCE TRUE
        CONFIGURE_COMMAND ""
        BUILD_COMMAND
        ${MAKE_EXE} -j${MPAS_NJOBS} ${MPAS_TARGET}
        CORE=${MPAS_CORE}
        SHAREDLIB=${MPAS_SHAREDLIB}
        DEBUG=${MPAS_DEBUG}
        AUTOCLEAN=true
)

set(MPAS_ROOT_DIR ${CMAKE_SOURCE_DIR}/MPAS)
set(MOD_DIR "${CMAKE_BINARY_DIR}/mod")
set(LIB_DIR "${CMAKE_BINARY_DIR}/lib")

add_custom_target(copy_mpas_artifacts ALL
        COMMAND ${CMAKE_COMMAND}
        -DMPAS_ROOT_DIR=${MPAS_ROOT_DIR}
        -DLIB_DIR=${LIB_DIR}
        -DMOD_DIR=${MOD_DIR}
        -P ${CMAKE_SOURCE_DIR}/cmake/copy_mpas_artifacts.cmake
)


#add_dependencies(copy_mpas_artifacts mpas)

