#Copyright (C) 2005-2009 Freescale Semiconductor, Inc. All Rights Reserved.
#
#The code contained herein is licensed under the GNU General Public
#License. You may obtain a copy of the GNU General Public License
#Version 2 or later at the following locations:
#
#http://www.opensource.org/licenses/gpl-license.html
#http://www.gnu.org/copyleft/gpl.html
################################################################################
#
#        @file   Makefile
#
#        @brief  configuration file to compile the cdrom_driver_testapp.
#
################################################################################
#Portability: ARM GCC
#
################################################################################
LTP_DIR=../../../..
BIN_DIR=../../

LOADLIBES+= -L$(LTP_DIR)/lib

SRCS=$(wildcard *.c)
OBJS=$(patsubst %.c,%*.o,$(SRCS))

TARGET=stream_benchmark

NEON_CFLAGS = -Wall -O3 -fsigned-char -march=armv7-a  -mfpu=neon
ifneq ($(findstring -mfloat-abi=hard,$(CFLAGS)), -mfloat-abi=hard)
NEON_CFLAGS += -mfloat-abi=softfp
else
NEON_CFLAGS += -mfloat-abi=hard
endif
SOFT_CFLAGS = -Wall -O3 -fsigned-char -march=armv7-a

all: $(TARGET)
	@echo "************************************************"
	@echo "** ALL : $(TARGET)                 **"
	@echo "************************************************"
	@echo

install:
	@echo "************************************************"
	@echo "** INSTALL : $(TARGET)             **"
	@echo "************************************************"
	ln -f $(TARGET) $(BIN_DIR)/bin
	ln -f stream_benchmark_soft $(BIN_DIR)/bin

clean:
	rm -f $(OBJS) $(TARGET) stream_benchmark_soft
	@echo "************************************************"
	@echo "** CLEAN : $(TARGET)               **"
	@echo "************************************************"

$(TARGET): Makefile
	$(CROSS_COMPILE)gcc $(NEON_CFLAGS) stream.c -o stream_benchmark
	$(CROSS_COMPILE)gcc $(SOFT_CFLAGS) stream.c -o stream_benchmark_soft

