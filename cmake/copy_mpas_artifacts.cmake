file(GLOB_RECURSE MPAS_LIBS
        "${MPAS_ROOT_DIR}/src/*.a")

file(GLOB_RECURSE MPAS_MODS
        "${MPAS_ROOT_DIR}/src/*.mod")

file(MAKE_DIRECTORY "${LIB_DIR}")
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
