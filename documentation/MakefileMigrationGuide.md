# Migrating from Makefile to CMake buildsystem WIP!

- make sure your firmware's repository is clean 
- make sure all top level ottocar libraries are up2date (bus-node-base, core, util, etc.) do not change the submodules those toplevel libraries bring with them (e.g. dont change libuavcan's version in bus-node-base). When an update is required for those internals the corresponding library will introduce the change and you can batch update all your internals with  git submodule update --init --recursive. Git submodules are all grown up and independant of their parent modules and such require explicit updating.

- copy the cmake splitter template *CMakeLists.txt.SplitterTemplate.cmake* file into the root of your firmware (Root is the same directory as your own Makefile) and rename it to CMakeLists.txt.
- Open the file and work on the TODOs.

- the whole buildsystem is programmed such that is assumes your firmware's sourcecode is in src/ and your tests are in test/
  (this doesn't mean that all your libraries must be in src/, they can be anywhere you like as long as it is inside your project's root directory)
- all paths within YOUR cmake (doesn't apply to paths within a library when you look at the cmake files there)
  are relative to your project's root

- copy *CMakeLists.txt.FirmwareTemplate.cmake* into your src/ folder and
  rename it to CMakeLists.txt.
- Some quick notes about cmake:
- You will chnage change in your project's name in the project() function call but you can refer to to it by using ${PROJECT_NAME}. ${VariableName} accesses a variable's content in CMake.

Some libraries require certain variables to be present for internal configuration.
A variable is declared using set(VariableName Content). Be aware that many things are a list for cmake and that you are better off without making something an explicit string with "".
Read up on how variables behave here TODO LINK TO MODERN CMAKE WEBSITE.
Many things that used to require you copying values manually are now automatically used so don't become suspicious when you don't have to specify e.g. DEVICE or RTOS anymore. A note on RTOS: the conveniences of using FreeRTOS have shown to be too great and because of that the new cmake buildsystem is designed to always include FreeRTOS by default.

- Work on the file's todos. If your firmware has libraries for it compilete this guide and then read the 'Custom Libraries' guide.


- copy the test CMakeList.txt template into your test/ folder


