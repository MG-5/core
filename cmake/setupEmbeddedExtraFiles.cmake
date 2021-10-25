include_guard(GLOBAL)
# Adds generation of .bin and .list files
# Makes target generate as an .elf file
# Invokes static library analyzer see core issue #3
# assumes CMAKE_OBJCOPY, CMAKE_OBJDUMP is correctly setup globally

# TargetName: your target from add_executable
# PathToCore: relative path from where you are calling this function to inside core folder without trailing /
#             (e.g. ../libraries/core)

function(SETUP_EXTRA_FILE_GENERATION TargetName PathToCore)
    # make it so firmware generates with .elf file ending
    set_target_properties(
            ${TargetName}
            PROPERTIES
            OUTPUT_NAME ${TargetName}
            SUFFIX ".elf"
    )

    add_custom_command(
            TARGET ${TargetName}
            POST_BUILD
            COMMAND ${CMAKE_OBJCOPY} ARGS -O ihex ${CMAKE_BINARY_DIR}/${TargetName}.elf ${CMAKE_BINARY_DIR}/${TargetName}.bin
            BYPRODUCTS ${CMAKE_BINARY_DIR}/${TargetName}.bin
    )

    add_custom_command(
            TARGET ${TargetName}
            POST_BUILD
            COMMAND ${CMAKE_OBJDUMP} ARGS -S ${CMAKE_BINARY_DIR}/${TargetName}.elf > ${CMAKE_BINARY_DIR}/${TargetName}.list
            BYPRODUCTS ${CMAKE_BINARY_DIR}/${TargetName}.list
    )

    add_custom_command(
            TARGET ${TargetName}
            POST_BUILD
            COMMAND ${CMAKE_CURRENT_LIST_DIR}/${PathToCore}/scripts/checkStaticLibraries.py ARGS ${CMAKE_BINARY_DIR}
    )
endfunction()