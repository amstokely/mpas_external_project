# MPASConfig.cmake

include(CMakeFindDependencyMacro)

# MPAS depends on these — forward them to consumers
find_dependency(MPI REQUIRED COMPONENTS Fortran C)
find_dependency(PnetCDF REQUIRED COMPONENTS Fortran C)

# Load the imported target
include("${CMAKE_CURRENT_LIST_DIR}/MPASTargets.cmake")
