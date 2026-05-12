# Name Mangling
macro(f2c_name_manging)
include(FortranCInterface)
FortranCInterface_HEADER(${PROJECT_BINARY_DIR}/fc.h
    MACRO_NAMESPACE "FC_"
    SYMBOL_NAMESPACE "FC_")
FortranCInterface_VERIFY()

MESSAGE(STATUS "Fortran - C - Interface -- FortranCInterface_GLOBAL_SUFFIX = ${FortranCInterface_GLOBAL_SUFFIX}")
MESSAGE(STATUS "Fortran - C - Interface -- FortranCInterface_GLOBAL_CASE = ${FortranCInterface_GLOBAL_CASE}")

IF(FortranCInterface_GLOBAL_SUFFIX STREQUAL "_" AND FortranCInterface_GLOBAL_CASE STREQUAL "LOWER")
    SET(FLEXIBLAS_MANGLE_DEFAULT 1)
    SET(FLEXIBLAS_MANGLE_NO_UNDERSCORE 0)
    SET(FLEXIBLAS_MANGLE_UPPERCASE 0)
    MESSAGE(STATUS "Use default Fortran name mangling.")
ELSEIF(FortranCInterface_GLOBAL_SUFFIX STREQUAL "" AND FortranCInterface_GLOBAL_CASE STREQUAL "LOWER")
    SET(FLEXIBLAS_MANGLE_DEFAULT 0)
    SET(FLEXIBLAS_MANGLE_NO_UNDERSCORE 1)
    SET(FLEXIBLAS_MANGLE_UPPERCASE 0)
    MESSAGE(STATUS "Use Windows-like Fortran name mangling.")
ELSEIF(FortranCInterface_GLOBAL_SUFFIX STREQUAL "" AND FortranCInterface_GLOBAL_CASE STREQUAL "UPPER")
    SET(FLEXIBLAS_MANGLE_DEFAULT 0)
    SET(FLEXIBLAS_MANGLE_NO_UNDERSCORE 0)
    SET(FLEXIBLAS_MANGLE_UPPERCASE 1)
    MESSAGE(STATUS "Use upper-case Fortran name mangling.")
ENDIF()
endmacro(f2c_name_manging)
