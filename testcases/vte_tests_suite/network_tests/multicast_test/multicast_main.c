/***
**Copyright (C) 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
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
    @file   multicast_main.c

    @brief   Network multicast test main function.

====================================================================================================
Revision History:
                            Modification     Tracking
Author                          Date          Number    Description of Changes
-------------------------   ------------    ----------  -------------------------------------------
V. ZAVJALOV/----             10/06/2004     TLSbo39738    Initial version

====================================================================================================
Portability:  ARM GCC  gnu compiler
==================================================================================================*/

/*==================================================================================================
Total Tests: 1

Test Executable Name:  multicast

Test Strategy:  A test for send and recive multicast message by use UDP sockets
=================================================================================================*/


#ifdef __cplusplus
extern "C"{
#endif

/*==================================================================================================
                                        INCLUDE FILES
==================================================================================================*/
/* Standard Include Files */
#include <errno.h>
    
/* Harness Specific Include Files. */
#include "test.h"
#include "usctest.h"

/* Verification Test Environment Include Files */
#include "multicast_test.h"

/*==================================================================================================
                                        LOCAL MACROS
==================================================================================================*/


/*==================================================================================================
                          LOCAL TYPEDEFS (STRUCTURES, UNIONS, ENUMS)
==================================================================================================*/


/*==================================================================================================
                                       LOCAL CONSTANTS
==================================================================================================*/


/*==================================================================================================
                                       LOCAL VARIABLES
==================================================================================================*/


/*==================================================================================================
                                       GLOBAL CONSTANTS
==================================================================================================*/


/*==================================================================================================
                                       GLOBAL VARIABLES
==================================================================================================*/
/* Extern Global Variables */
extern int  Tst_count;               /* counter for tst_xxx routines.         */
extern char *TESTDIR;                /* temporary dir created by tst_tmpdir() */

/* Global Variables */
char *TCID     = "TGE-LV-CS-0030"; 	     /* test program identifier.          */
int  TST_TOTAL = 1;                  /* total number of tests in this file.   */

/*==================================================================================================
                                   GLOBAL FUNCTION PROTOTYPES
==================================================================================================*/
void cleanup();
void setup();
int main(int argc, char **argv);

/*==================================================================================================
                                   LOCAL FUNCTION PROTOTYPES
==================================================================================================*/


/*==================================================================================================
                                       GLOBAL FUNCTIONS
==================================================================================================*/

/*================================================================================================*/
/*===== cleanup =====*/
/**
@brief  Performs all one time clean up for this test on successful
				completion,  premature exit or  failure. Closes all temporary
				files, removes all temporary directories exits the test with
				appropriate return code by calling tst_exit() function.cleanup

@param  Input :      None.
        Output:      None.
  
@return Nothing
*/
/*================================================================================================*/
void cleanup()
{
    /* VTE : Actions needed to get a stable target environment */
	int VT_rv = TFAIL;
		
	VT_rv = VT_multicast_test_cleanup();
	if (VT_rv != TPASS)
	{
		tst_resm(TWARN, "VT_cleanup() Failed : error code = %d", VT_rv);
	}

    /* Exit with appropriate return code. */
    tst_exit();
}

/*==================================================================================================
                                       LOCAL FUNCTIONS
==================================================================================================*/

/*================================================================================================*/
/*===== setup =====*/
/**
@brief  Performs all one time setup for this test. This function is
        typically used to capture signals, create temporary dirs
				and temporary files that may be used in the course of this test.

@param  Input :      None.
        Output:      None.
  
@return On failure - Exits by calling cleanup().
        On success - returns 0.
*/
/*================================================================================================*/
void setup()
{
	int VT_rv = TFAIL;
	
    /* VTE : Actions needed to prepare the test running */
	VT_rv = VT_multicast_test_setup();
	if (VT_rv != TPASS)
	{
		tst_brkm(TBROK , cleanup, "VT_multicast_setup() Failed : error code = %d", VT_rv);
	}
    
    return;
}


/*================================================================================================*/
/*===== main =====*/
/**
@brief  Entry point to this test-case. It parses all the command line
        inputs, calls the global setup and executes the test. It logs
  	the test status and results appropriately using the LTP API's
	On successful completion or premature failure, cleanup() func
	is called and test exits with an appropriate return code.

@param  Input :      argc - number of command line parameters.
        Output:      **argv - pointer to the array of the command line parameters.
				Describe input arguments to this test-case
				-l - Number of iteration
				-v - Prints verbose output
				-V - Prints the version number
  
@return On failure - Exits by calling cleanup().
        On success - exits with 0 exit value.
*/
/*================================================================================================*/
int main(int argc, char **argv)
{
	int VT_rv = TFAIL;

    /* perform global test setup, call setup() function. */
    setup();

    /* Print test Assertion using tst_resm() function with argument TINFO. */
    tst_resm(TINFO, "Testing if %s test case is OK", TCID);

    /* VTE : Execute test, print results and exit test scenario */
    VT_rv = VT_multicast_test(argc,argv);
	
    if(VT_rv == TPASS)
    {
        tst_resm(TPASS, "test case %s worked as expected", TCID);
    }
    else
    {
        tst_resm(TFAIL, "test case %s did NOT work as expected", TCID);
    }
		
	/* cleanup test allocated ressources */	
    cleanup(); 

	return VT_rv;
}
