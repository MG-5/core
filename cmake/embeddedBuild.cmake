set(MakeExport_MCU -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard)
set(MakeExport_LDSCRIPT STM32F405RGTx_FLASH.ld)


# buildengine
set(Cstd c11)
set(CXXstd c++17)
set(Optimisation -Os)
set(Specs --specs=nano.specs --specs=nosys.specs)
set(Defs ${CORE_DEFS} ${BUS_NODE_BASE_DEFS})

set(CFlags -std=c11 ${Optimisation} -fno-builtin-log)

set(CppFlags -ffunction-sections -fdata-sections -fno-common
        -pedantic -Wall -Wextra
        -Wno-unused-parameter -Wno-unused-variable
        -fexec-charset=cp1252
        ${Specs})

set(CxxFlags -std=c++17 ${Optimisation}
        -fno-exceptions -fno-rtti -fno-unwind-tables -Wno-register -fno-math-errno)

# generator expressions have some quirky behaviour when multiple lists separated by spaces
# are directly used, to avoid it just concat all lists beforehand
set(c_lang_options ${MakeExport_MCU} ${CFlags} ${CppFlags})
set(cpp_lang_options ${MakeExport_MCU} ${CxxFlags} ${CppFlags})
set(asm_lang_options -x assembler-with-cpp ${CFlags} ${MakeExport_MCU} ${CppFlags})

# must come before any target has been defined or else options won't stick
# all targets must be built with the same compile options or bad things happen
add_compile_options(
        "$<$<COMPILE_LANGUAGE:C>:${c_lang_options}>"
        "$<$<COMPILE_LANGUAGE:CXX>:${cpp_lang_options}>"
        "$<$<COMPILE_LANGUAGE:ASM>:${asm_lang_options}>"
)

set(all_defs ${Defs} ${MakeExport_C_DEFS} ${MakeExport_AS_DEFS})
add_definitions(${all_defs})


set(LinkOptions
    ${Specs}
    --static
    -Wl,--gc-sections
    -Wl,--print-memory-usage
    -Wl,-Map=${FirmwareName}.map
    -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group
    -T${PROJECT_SOURCE_DIR}/${HalDir}/${MakeExport_LDSCRIPT}
    ${MakeExport_MCU})



