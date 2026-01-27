file(GLOB_RECURSE MPAS_LIBS
        "${MPAS_ROOT_DIR}/src/*.a")

file(GLOB_RECURSE MPAS_MODS
        "${MPAS_ROOT_DIR}/src/*.mod")

file(MAKE_DIRECTORY "${LIB_DIR}")
file(MAKE_DIRECTORY "${MOD_DIR}")
file(MAKE_DIRECTORY "${MOD_DIR}")

foreach(f IN LISTS MPAS_LIBS)
    get_filename_component(fname "${f}" NAME)
    file(COPY_FILE
            "${f}"
            "${LIB_DIR}/${fname}"
            ONLY_IF_DIFFERENT)
endforeach()

foreach(f IN LISTS MPAS_MODS)
    get_filename_component(fname "${f}" NAME)
    file(COPY_FILE
            "${f}"
            "${MOD_DIR}/${fname}"
            ONLY_IF_DIFFERENT)
endforeach()
# Copy package config files flat into build root

set(_SCRIPT_DIR "${CMAKE_CURRENT_LIST_DIR}")

configure_file(
        "${_SCRIPT_DIR}/MPASConfig.cmake"
        "${CMAKE_BINARY_DIR}/MPASConfig.cmake"
        COPYONLY
)

configure_file(
        "${_SCRIPT_DIR}/MPASTargets.cmake"
        "${CMAKE_BINARY_DIR}/MPASTargets.cmake"
        COPYONLY
)

