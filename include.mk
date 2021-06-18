ifeq ($(RELEASE),1)
CONFIGURATION   := release
RELEASE_OPT     ?= 3
OPTIMIZATION    := -O$(RELEASE_OPT) -g
else
CONFIGURATION   := debug
OPTIMIZATION    := -Og -g
DEFS            += DEBUG
endif

ROOTDIR     := $(dir $(firstword $(MAKEFILE_LIST)))
COREDIR     := $(dir $(lastword $(MAKEFILE_LIST)))
MXDIR       := $(ROOTDIR)$(TARGET).cubemx/
OUTPUT_DIR  := $(ROOTDIR)build/$(CONFIGURATION)/
OBJDIR      := $(OUTPUT_DIR)/obj

INCDIRS +=          \
$(COREDIR)inc       \
$(COREDIR)inc/core  \
$(COREDIR)chip

SOURCES +=                          \
$(COREDIR)src/abi.cpp               \
$(COREDIR)src/build_information.cpp \
$(COREDIR)src/fault_handler.c       \
$(COREDIR)src/hash.cpp              \
$(COREDIR)src/std.cpp

TRACEALYZER_SUPPORT ?= 1

DEFS += STM32_PCLK1=$(STM32_PCLK1) STM32_TIMCLK1=$(STM32_TIMCLK1)

ifeq ($(RTOS),none)
DEFS += FW_USE_RTOS=0
else ifeq ($(RTOS),freertos)
DEFS += FW_USE_RTOS=1
else
$(error Unknown firmware type)
endif

# CubeMX
include $(TARGET).cubemx/Makefile

SOURCES += $(foreach source,$(C_SOURCES) $(ASM_SOURCES),$(MXDIR)$(source))
INCDIRS += $(C_INCLUDES:-I%=$(MXDIR)%)
INCDIRS += $(AS_INCLUDES:-I%=$(MXDIR)%)

LDSCRIPT := $(MXDIR)$(LDSCRIPT)

# Tracealyzer
ifeq ($(TRACEALYZER_SUPPORT), 1)
ifeq ($(RTOS),freertos)
INCDIRS	+= $(COREDIR)Tracealyzer/Include
SOURCES	+= $(wildcard $(COREDIR)Tracealyzer/Src/*.c)
endif
endif

include $(COREDIR)mk/build-info.mk

# Include actual rules
include $(COREDIR)mk/rules.mk