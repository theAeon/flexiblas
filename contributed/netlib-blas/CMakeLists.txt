IF ( LAPACK_API_VERSION VERSION_GREATER 3.9.1 )
    MESSAGE(STATUS "Netlib BLAS uses the scaling/overflow/underflow improvements from LAPACK 3.10")
    SET( ROTG
        drotg.f90
        srotg.f90
        crotg.f90
        zrotg.f90
        )
    SET (NRM
        dznrm2.f90
        scnrm2.f90
        dnrm2.f90
        snrm2.f90

        )

ELSE ()
    MESSAGE(STATUS "Netlib BLAS uses the pre LAPACK 3.10.0 codes")
    SET( ROTG
        drotg.f
        srotg.f
        crotg.f
        zrotg.f
        )
    SET( NRM
        dznrm2.f
        scnrm2.f
        dnrm2.f
        snrm2.f
        )
ENDIF()

SET(NETLIBLVL3
    cgemm.f
    chemm.f
    cherk.f
    cher2k.f
    csymm.f
    csyr2k.f
    csyrk.f
    ctrmm.f
    ctrsm.f
    dgemm.f
    dsymm.f
    dsyr2k.f
    dsyrk.f
    dtrmm.f
    dtrsm.f
    sgemm.f
    ssymm.f
    ssyr2k.f
    ssyrk.f
    strmm.f
    strsm.f
    zgemm.f
    zhemm.f
    zher2k.f
    zherk.f
    zsymm.f
    zsyr2k.f
    zsyrk.f
    ztrmm.f
    ztrsm.f
)

SET(NETLIBLVL12
    ${ROTG}
    ${NRM}
    caxpy.f
    ccopy.f
    cdotc.f
    cdotu.f
    cgbmv.f
    cgemv.f
    cgerc.f
    cgeru.f
    chbmv.f
    chemv.f
    cher2.f
    cher.f
    chpmv.f
    chpr2.f
    chpr.f
    cscal.f
    csrot.f
    csscal.f
    cswap.f
    ctbmv.f
    ctbsv.f
    ctpmv.f
    ctpsv.f
    ctrmv.f
    ctrsv.f
    dasum.f
    daxpy.f
    dcabs1.f
    dcopy.f
    ddot.f
    dgbmv.f
    dgemv.f
    dger.f
    drot.f
    drotm.f
    drotmg.f
    dsbmv.f
    dscal.f
    dsdot.f
    dspmv.f
    dspr2.f
    dspr.f
    dswap.f
    dsymv.f
    dsyr2.f
    dsyr.f
    dtbmv.f
    dtbsv.f
    dtpmv.f
    dtpsv.f
    dtrmv.f
    dtrsv.f
    dzasum.f
    icamax.f
    idamax.f
    isamax.f
    izamax.f
    lsame.f
    sasum.f
    saxpy.f
    scabs1.f
    scasum.f
    scopy.f
    sdot.f
    sdsdot.f
    sgbmv.f
    sgemv.f
    sger.f
    srot.f
    srotm.f
    srotmg.f
    ssbmv.f
    sscal.f
    sspmv.f
    sspr2.f
    sspr.f
    sswap.f
    ssymv.f
    ssyr2.f
    ssyr.f
    stbmv.f
    stbsv.f
    stpmv.f
    stpsv.f
    strmv.f
    strsv.f
    xerbla_array.f
    xerbla.f
    zaxpy.f
    zcopy.f
    zdotc.f
    zdotu.f
    zdrot.f
    zdscal.f
    zgbmv.f
    zgemv.f
    zgerc.f
    zgeru.f
    zhbmv.f
    zhemv.f
    zher2.f
    zher.f
    zhpmv.f
    zhpr2.f
    zhpr.f
    zscal.f
    zswap.f
    ztbmv.f
    ztbsv.f
    ztpmv.f
    ztpsv.f
    ztrmv.f
    ztrsv.f
    )

SET (NETLIBSRC
    ${NETLIBLVL3}
    ${NETLIBLVL12}
    )

message(STATUS "AGGREGATE_FILES: ${AGGREGATE_FILES}")

if (AGGREGATE_FILES)
    SET(OUTNAMEF "${CMAKE_CURRENT_BINARY_DIR}/netlibblas.f")
    SET(OUTNAMEF90 "${CMAKE_CURRENT_BINARY_DIR}/netlibblas_90.f90")
    file(WRITE "${OUTNAMEF}" "\n")
    file(WRITE "${OUTNAMEF90}" "\n")

    foreach(srcfile IN LISTS NETLIBSRC)
        if (srcfile MATCHES ".*\.f$")
            file(READ "${srcfile}" FILE_CONTENT)
            file(APPEND "${OUTNAMEF}" ${FILE_CONTENT})
            file(APPEND "${OUTNAMEF}" "\n")
        endif()
        if (srcfile MATCHES ".*\.f90$")
            file(READ "${srcfile}" FILE_CONTENT)
            file(APPEND "${OUTNAMEF90}" ${FILE_CONTENT})
            file(APPEND "${OUTNAMEF90}" "\n")
        endif()
    endforeach()
    SET(NETLIBSRC ${OUTNAMEF} ${OUTNAMEF90})
endif()

if( (CMAKE_Fortran_COMPILER_ID STREQUAL "VisualAge" ) OR  # CMake 2.6
	(CMAKE_Fortran_COMPILER_ID STREQUAL "XL" ) )          # CMake 2.8
	# 	if( "${CMAKE_Fortran_FLAGS}" MATCHES "-qflttrap=[a-zA-Z:]:enable" )
	# 		set( FPE_EXIT TRUE )
	# 	endif()

	if( NOT ("${CMAKE_Fortran_FLAGS}" MATCHES "-qfixed") )
		message( STATUS "BLAS -- Enabling fixed format F90/F95 with -qfixed" )
		set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qfixed")
		#         CACHE STRING "Flags for Fortran compiler." FORCE )
	endif()
endif()


# Disable Warings for BLAS
if ( CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" )
	SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffloat-store -Wno-conversion -Wno-maybe-uninitialized")
endif()

if (FLEXIBLAS_INCLUDE_DIR)
    INCLUDE_DIRECTORIES(${FLEXIBLAS_INCLUDE_DIR})
else ()
    INCLUDE_DIRECTORIES(${PROJECT_BINARY_DIR}/include)
endif ()
add_library (flexiblas_netlib_objs OBJECT ${NETLIBSRC})
add_library (flexiblas_netlib_minus3 OBJECT ${NETLIBLVL12})

