# call specially created make file that prints out variables
# expecting output from the following make code
#
# export:
#	@printf 'MakeExport_SOURCES $(C_SOURCES) $(ASM_SOURCES)"'
#	@printf 'MakeExport_MCU_Flags $(MCU)'
#	@printf 'MakeExport_DEFS $(AS_DEFS) $(C_DEFS)'
#	@printf 'MakeExport_INCLUDES $(AS_INCLUDES) $(C_INCLUDES)'
#	@printf 'MakeExport_LDSCRIPT $(LDSCRIPT)'


# Sets the following variables in parent scope
# MakeExport_SOURCES, MakeExport_MCU_Flags, MakeExport_DEFS, MakeExport_INCLUDES, MakeExport_LDSCRIPT
# prefixDirectory will be applied to sources, includes and ldscript
function(GET_CUBEMX_VARIABLES prefixDirectory)
    execute_process(COMMAND make --no-print-directory -C ${PROJECT_SOURCE_DIR}/drive_controller.cubemx/
            OUTPUT_VARIABLE out)

    # split output into list
    # a list is a string separated by ; for cmake btw
    string(REPLACE "\n" ";" out ${out})
    list(LENGTH out length)
    if(NOT length MATCHES 6)
        # 5 entries + one empty line
        message(FATAL_ERROR "Unable to extract information from makefile: list of lists is too short")
    endif()

    foreach(entry IN LISTS out)
        # strip away any -I or -D
        string(REPLACE "-I" "" entry "${entry}")
        #string(REPLACE "-D" "" entry "${entry}")

        # split into list, entries are expected to be whitespace separated
        string(REPLACE " " ";" entryList "${entry}")

        list(LENGTH entryList length)
        if (${length} LESS 2)
            continue()
        endif()

        # get first element (name of entry), save it and remove it from the main list
        list(GET entryList 0 entryName)
        list(REMOVE_AT entryList ${entryList} "0")

        if(entryName MATCHES "^MakeExport_SOURCES")
            list(TRANSFORM entryList PREPEND "${prefixDirectory}/")
            set(MakeExport_SOURCES ${entryList} PARENT_SCOPE)
            continue()
        endif()
        if(entryName MATCHES "^MakeExport_MCU_Flags")
            set(MakeExport_MCU_Flags ${entryList} PARENT_SCOPE)
            continue()
        endif()
        if(entryName MATCHES "^MakeExport_DEFS")
            set(MakeExport_DEFS ${entryList} PARENT_SCOPE)
            continue()
        endif()
        if(entryName MATCHES "^MakeExport_INCLUDES")
            list(TRANSFORM entryList PREPEND "${prefixDirectory}/")
            set(MakeExport_INCLUDES ${entryList} PARENT_SCOPE)
            continue()
        endif()
        if(entryName MATCHES "^MakeExport_LDSCRIPT")
            list(TRANSFORM entryList PREPEND "${prefixDirectory}/")
            set(MakeExport_LDSCRIPT ${entryList} PARENT_SCOPE)
            continue()
        endif()
    endforeach()
endfunction()