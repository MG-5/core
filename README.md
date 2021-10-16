# core
TODO DESCRIBE NEW BUILDSYSTEM BASED ON CMAKE  
TODO DESCRIBE SETUP OF NEW PROJECT   
TODO DESCRIBE BUILDSYSTEMS ASSUMPTIONS ABOUT COMPILER  
TODO RECOMMEND NINJA BUILD GENERATOR  


TODO DESCRIBE PROJECT SPLITTER
```cmake
cmake_minimum_required(VERSION 3.15)
include("libraries/core/cmake/compilerSetup.cmake")

project(cmake_splitter VERSION 0.0.1 LANGUAGES CXX C)


if(${isEmbeddedCompiler})
    include("src/CMakeLists.txt")
else()
    include("test/CMakeLists.txt")
endif()
```

Core library containing the build system, common functionalities required by all firmwares and [Tracealyzer for FreeRTOS](https://percepio.com/tz/freertostrace/).

TODO UPDATE, MOVE OVER CUBEMX SETUP OF CORE
### Please consult the detailed [README of bus-node-base](https://ottocar.cs.ovgu.de/gitlab/ottocar/Firmware/generation/bus-node-base/-/blob/master/README.md) for informations about a **full setup** with CubeMX, VisualCode, UAVCAN(optional) and more.


### CMake setup

Expects *isEmbeddedCompiler* variable from *core/cmake/detectCompilerType.cmake* in parent scope.

Requires following libraries:

- freertos
- hal_headers

Exports following libraries:

- core
- tracealyzer

Core features automatic CMake translation of CubeMX Makefiles when the following is added to the Makefile

```makefile
export:
	@printf 'MakeExport_SOURCES $(C_SOURCES) $(ASM_SOURCES)\n'
	@printf 'MakeExport_MCU_Flags $(MCU)\n'
	@printf 'MakeExport_DEFS $(AS_DEFS) $(C_DEFS)\n'
	@printf 'MakeExport_INCLUDES $(AS_INCLUDES) $(C_INCLUDES)\n'
	@printf 'MakeExport_LDSCRIPT $(LDSCRIPT)\n'
```

This will 