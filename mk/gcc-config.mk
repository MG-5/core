##
## This file is part of the libopencm3 project.
##
## Copyright (C) 2014 Frantisek Burian <BuFran@seznam.cz>
##
## This library is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This library is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this library.  If not, see <http://www.gnu.org/licenses/>.
##

###############################################################################
# The support makefile for GCC compiler toolchain, the rules part.
#
# please read mk/README for specification how to use this file in your project


PREFIX      ?= arm-none-eabi

CC          := $(PREFIX)-gcc
CXX         := $(PREFIX)-g++
LD          := $(PREFIX)-gcc
ar          := $(PREFIX)-ar
as          := $(PREFIX)-as
OBJCOPY     := $(PREFIX)-objcopy
OBJDUMP     := $(PREFIX)-objdump
GDB         := $(PREFIX)-gdb
SIZE        := $(PREFIX)-size
