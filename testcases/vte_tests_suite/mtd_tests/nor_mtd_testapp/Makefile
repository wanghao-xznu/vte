#Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
#
#The code contained herein is licensed under the GNU General Public
#License. You may obtain a copy of the GNU General Public License
#Version 2 or later at the following locations:
#
#http://www.opensource.org/licenses/gpl-license.html
#http://www.gnu.org/copyleft/gpl.html
###############################################################################
#
#    @file   Makefile
#
#    @brief  configuration file to compile the sockets test.
#
###############################################################################
#Revision History:
#                            Modification     Tracking
#Author/core ID                  Date          Number    Description of Changes
#-------------------------   ------------    ----------  ----------------------
#S.ZAVJALOV/ZVJS001C          27/07/2004     TLSbo40261  Initial version
#L.DELASPRE/rc149c            02/08/2004     TLSbo40891  VTE 1.4 integration
#L.DELASPRE/rc149c            06/10/2004     TLSbo42821  VTE 1.5.1 integration
#L.Delaspre/rc149c            08/12/2004     TLSbo40142  Update with Freescale identity
#A.Ozerov/b00320              19/04/2006     TLSbo61865  Minor fixes.
#Rakesh S Joshi/r65956        25/07/2007     ENGR42511   Added CFLAG for MXC92323 ARCH.
#
###############################################################################
# To avoid compile definition duplication error, no need to include kernel
# header file
#CFLAGS    +=     -Wall -I../../../../include -I$(KLINUX_BLTDIR)/include -I$(KLINUX_SRCDIR)/include
CFLAGS    +=     -Wall -I../../../../include
LOADLIBES +=     -L../../../../lib -lltp

#include $(KLINUX_BLTDIR)/.config

#ifeq "$(CONFIG_ARCH_MXC92323)" "y"
#CFLAGS += -DCONFIG_ARCH_MXC92323
#endif

SRCS = $(wildcard *.c)
OBJS = $(patsubst %.c,%.o,$(SRCS))

TARGET = nor_mtd_testapp

all: $(TARGET)
	rm -f $(OBJS)
	@echo "***********************************************"
	@echo "** ALL : $(TARGET)                    **"
	@echo "***********************************************"
	@echo

install:
	ln -f $(TARGET) ../../../bin
	@echo "***********************************************"
	@echo "** INSTALL : $(TARGET)                **"
	@echo "***********************************************"
	@echo

clean:
	rm -f $(OBJS) $(TARGET)
	@echo "***********************************************"
	@echo "** CLEAN : $(TARGET)                  **"
	@echo "***********************************************"
	@echo

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(LOADLIBES) -o $@

$(OBJS) : $(SRCS)

$(SRCS) : nor_mtd_test.h
