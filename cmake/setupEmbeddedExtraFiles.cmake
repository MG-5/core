# assumes CMAKE_OBJCOPY, CMAKE_OBJDUMP is correctly setup globally
# also assumes target FirmwareName already exists (target = add_executable or add_library)
# modifies target so that it generates with TargetName.elf filename

function(SETUP_EXTRA_FILE_GENERATION TargetName)
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
            COMMAND ${CMAKE_OBJCOPY} ARGS -O ihex "${CMAKE_BINARY_DIR}/${TargetName}.elf" "${CMAKE_BINARY_DIR}/${TargetName}.hex"
    )

    add_custom_command(
            TARGET ${TargetName}
            POST_BUILD
            COMMAND ${CMAKE_OBJDUMP} ARGS -S "${CMAKE_BINARY_DIR}/${TargetName}.elf" > "${CMAKE_BINARY_DIR}/${TargetName}.list"
    )
endfunction()