include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/extractBuildinfoFromMakefile.cmake)

# Extracts C and H files from cubemx makefile and creates three targets
# freertos - realtime os complete with heap, and port
# hel_headers - all cubemx generated headers without source files
# hal - complete hal with sources and headers
function(GENERATE_CUBEMX_TARGETS halDirectory generateFreertosTarget)
    GET_CUBEMX_VARIABLES(${halDirectory})

    set(HalSources)
    set(FreertosSources)
    foreach (entry IN LISTS MakeExport_SOURCES)
        if (entry MATCHES "Middlewares/Third_Party/FreeRTOS/Source/")
            if (entry MATCHES "CMSIS_RTOS_V2")
                # cmsis_os2.c is part of hal, but hides inside freertos sources
                list(APPEND HalSources ${entry})
            else ()
                list(APPEND FreertosSources ${entry})

            endif ()
        else ()
            list(APPEND HalSources ${entry})
        endif ()
    endforeach ()

    set(HalIncludes)
    set(FreertosIncludes)
    foreach (entry IN LISTS MakeExport_INCLUDES)
        if (entry MATCHES "Middlewares/Third_Party/FreeRTOS/Source")
            if (entry MATCHES "CMSIS_RTOS_V2")
                # cmsis_os2.c is part of hal, but hides inside freertos sources
                list(APPEND HalIncludes ${entry})
            else ()
                list(APPEND FreertosIncludes ${entry})

            endif ()
        else ()
            list(APPEND HalIncludes ${entry})
        endif ()
    endforeach ()

    message("${HalSources}")

    if (generateFreertosTarget)
        add_library(freertos STATIC
                ${FreertosSources})
        target_include_directories(freertos PUBLIC ${FreertosIncludes})
        target_link_libraries(freertos PUBLIC hal_headers core)
    endif ()

    add_library(hal_headers INTERFACE)
    target_include_directories(hal_headers INTERFACE ${HalIncludes})

    add_library(hal STATIC
            ${HalSources}
            )
    target_link_libraries(hal PUBLIC hal_headers freertos)
endfunction()