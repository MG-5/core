# core

Core library containing the build system, common functionalities required by all firmwares and [Tracealyzer for FreeRTOS](https://percepio.com/tz/freertostrace/).

### Please consult the detailed [README of bus-node-base](https://ottocar.cs.ovgu.de/gitlab/ottocar/Firmware/generation/bus-node-base/-/blob/master/README.md) for informations about a **full setup** with CubeMX, VisualCode, UAVCAN(optional) and more.

Here is a minimal *Makefile*:

```make
TARGET  := minimal-core-project
RTOS    := freertos
DEVICE  := stm32f103re

INCDIRS         := include/
SOURCES         := src/main.cpp

# include build engine
include core/include.mk
```