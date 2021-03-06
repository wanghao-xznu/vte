/***
**Copyright (C) 2006-2009 Freescale Semiconductor, Inc. All Rights Reserved.
**
**The code contained herein is licensed under the GNU General Public
**License. You may obtain a copy of the GNU General Public License
**Version 2 or later at the following locations:
**
**http://www.opensource.org/licenses/gpl-license.html
**http://www.gnu.org/copyleft/gpl.html
**/
/*================================================================================================*/
/**
        @file   usb_otg_test.h

        @brief  header file for USB-OTG driver test.
====================================================================================================
Revision History:
                            Modification     Tracking
Author/core ID                  Date          Number    Description of Changes
-------------------------   ------------    ----------  --------------------------------------------
A.Ozerov/B00320              07/04/2006     TLSbo58840  Initial version
A.Ozerov/B00320              29/06/2006     TLSbo71035  Coding style was changed.

====================================================================================================
Portability: ARM GCC

==================================================================================================*/
#ifndef USB_OTG_TEST_H
#define USB_OTG_TEST_H

#ifdef __cplusplus
extern "C"{
#endif

/*==================================================================================================
                                        DEFINES AND MACROS
==================================================================================================*/
#define        USB_DEV "otg_message"

#define        OTG_APPLICATION
#define        OTG_LINUX

#define        ASSERT(a) if(a != TPASS)rv = TFAIL;

/*==================================================================================================
                                        INCLUDE FILES
==================================================================================================*/
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/poll.h>
#include <errno.h>

#include <string.h>
#include <stdio.h>

/* API's Include Files */
#include "otg/otg-fw.h"
#include "otg/otg-fw-mn.h"

/*==================================================================================================
                                    FUNCTION PROTOTYPES
==================================================================================================*/
int VT_usb_otg_test_cleanup(void);
int VT_usb_otg_test_setup(void);  
int VT_usb_otg_test(int switch_fct);

#ifdef __cplusplus
}
#endif

#endif        /* USB_OTG_TEST_H */
