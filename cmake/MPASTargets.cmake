add_library(MPAS::model INTERFACE IMPORTED)

get_filename_component(_MPAS_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(_MPAS_LIB_DIR "${_MPAS_DIR}/lib")
set(_MPAS_MOD_DIR "${_MPAS_DIR}/mod")

file(GLOB MPAS_LIBS "${_MPAS_LIB_DIR}/*.a")

target_link_libraries(MPAS::mpas INTERFACE ${MPAS_LIBS})

# THIS is what makes Fortran modules visible
target_include_directories(MPAS::mpas INTERFACE "${_MPAS_MOD_DIR}")
