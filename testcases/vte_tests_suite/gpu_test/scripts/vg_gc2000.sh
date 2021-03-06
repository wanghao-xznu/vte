#!/bin/sh
#
# Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
###############################################################################
#
#    @file   vg.sh
#
#    @brief  shell script template for testcase design "gpu" is where to modify block.
#
################################################################################
#Revision History:
#                            Modification     Tracking
#Author                          Date          Number    Description of Changes
#------------------------   ------------    ----------  -----------------------
#Hake Huang/-----             20110817     N/A          Initial version
#Andy Tian                    05/15/2012   N/A          add wait for background
#Shelly Cheng                 20130517     N/A          change concurrent demo process
#Shelly Cheng                 20131028     N/A          add X backend vg perf
#                    
# 
################################################################################

# Function:     setup
#
# Description:  - Check if required commands exits
#               - Export global variables
#               - Check if required config files exits
#               - Create temporary files and directories
#
# Return        - zero on success
#               - non zero on failure. return value from commands ($RC)
setup()
{
	#TODO Total test case
	export TST_TOTAL=4

	export TCID="setup"
	export TST_COUNT=0
	RC=0

	trap "cleanup" 0
	if [ -z "$GPU_DRIVER_PATH" ];then
		export GPU_DRIVER_PATH=/usr/lib
	fi
	mv $GPU_DRIVER_PATH/libOpenVG.so $GPU_DRIVER_PATH/libOpenVG.so.bak
    ln -s $GPU_DRIVER_PATH/libOpenVG_3D.so $GPU_DRIVER_PATH/libOpenVG.so
	echo ====== Using 3D VG library =======    
	return $RC
}

# Function:     cleanup
#
# Description   - remove temporary files and directories.
#
# Return        - zero on success
#               - non zero on failure. return value from commands ($RC)
cleanup()
{
	RC=0

	#TODO add cleanup code here
	rm $GPU_DRIVER_PATH/libOpenVG.so
	mv $GPU_DRIVER_PATH/libOpenVG.so.bak $GPU_DRIVER_PATH/libOpenVG.so
	return $RC
}


# Function:     test_case_01
# Description   - Test if gles applications sequence ok
#  
test_case_01()
{
    #TODO give TCID 
    TCID="vg_test"
    #TODO give TST_COUNT
    TST_COUNT=1
    RC=0

    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "

    cd ${TEST_DIR}/${APP_SUB_DIR}
    #TODO add function test scripte here
    echo "==========================="
    echo tiger
    echo "==========================="
    ./tiger -frameCount 1000 || RC="tiger"

    cd ${TEST_DIR}/${APP_SUB_DIR}
    echo "==========================="
    echo sample_test
    echo "==========================="
	./sample_test_vg 1000 || RC=$(echo $RC sample_test)

    echo $RC

    if [ "$RC" = "0" ]; then
        RC=0
    else
        RC=1
    fi

    return $RC

}

# Function:     test_case_02
# Description   - Test if gles concurrent ok
#  
test_case_02()
{
    #TODO give TCID 
    TCID="vg_multi_test"
    #TODO give TST_COUNT
    TST_COUNT=2
    RC=0

    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "

    #TODO add function test scripte here
    cd ${TEST_DIR}/${APP_SUB_DIR}
    #TODO add function test script here
    echo "==========================="
    echo tiger
    echo "==========================="
    ./tiger -frameCount 10000 &
    pid_tiger=$!

    cd ${TEST_DIR}/${APP_SUB_DIR}
    echo "==========================="
    echo sample_test
    echo "==========================="
	./sample_test_vg 10000 &
    
    wait $pid_tiger 
    RC=$?
    wait

    echo $RC

    if [ "$RC" = "0" ]; then
        RC=0
    else
        RC=1
    fi

    return $RC
}

# Function:     test_case_03
# Description   - Test if gles conformance ok
#  
test_case_03()
{
    #TODO give TCID 
    TCID="vg_conform_test"
    #TODO give TST_COUNT
    TST_COUNT=3
    RC=0

    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "

    #TODO add function test scripte here
    cd ${TEST_DIR}/${APP_SUB_DIR}
    echo "==========================="
    echo vg1.1 conformance
    echo "==========================="
    if [ -e vg11_conform/generation/make/linux/bin ]; then
        cd vg11_conform/generation/make/linux/bin
        ./generator.exe || RC="cts_1.1"
    fi

    echo $RC

    if [ $RC = "0" ]; then
        RC=0
    else
        RC=1
    fi

    return $RC
}

test_case_04()
{
    #TODO give TCID 
    TCID="gles_pm_test"
    #TODO give TST_COUNT
    TST_COUNT=3
    RC=0

    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "

    cd ${TEST_DIR}/${APP_SUB_DIR}
    #TODO add function test scripte here
    echo "==========================="
    echo tiger
    echo "==========================="
    ./tiger -frameCount 1000 &
    td=$!

    rtc_testapp_6 -T 50
    sleep 1
    rtc_testapp_6 -T 50
    sleep 1
    rtc_testapp_6 -T 50
    sleep 1
    rtc_testapp_6 -T 50
    sleep 1
    rtc_testapp_6 -T 50
    sleep 1

    wait $td
    RC=$?
    if [ $RC = 0 ];then
        echo "TEST PASS"
    else
        echo "TEST FAIL"
    fi
    return $RC
}

test_case_05()
{
    #TODO give TCID 
    TCID="vgmark_test"
    #TODO give TST_COUNT
    TST_COUNT=1
    RC=0

    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
    
	cpufreq-set -g performance
	cd ${TEST_DIR}/${APP_SUB_DIR}
	echo "==========================="
	echo vgMark
	echo "==========================="
	cd vgmark_10
	cp script.lua_gc2000 script.lua
	./fm_oes_vg_player || RC=$(echo $RC vgmark)
    echo $RC
	if [ "$RC" = "0" ]; then
		RC=0
	else
		RC=1
	fi
    cpufreq-set -g interactive
	return $RC

}
test_case_06()
{
	    #TODO give TCID
		TCID="MULTI_BUFFER"
		#TODO give TST_COUNT
		TST_COUNT=1
		RC=0
		cd ${TEST_DIR}/${APP_SUB_DIR}
		echo "==========================="
		echo fb multiple buffer test
		echo "==========================="
		export FB_MULTI_BUFFER=1
		echo FB_MULTI_BUFFER=1
		./tiger -frameCount 300 
		export FB_MULTI_BUFFER=2
		echo FB_MULTI_BUFFER=2
		./tiger -frameCount 300
		export FB_MULTI_BUFFER=3
		echo FB_MULTI_BUFFER=3
		./tiger -frameCount 300
		export FB_MULTI_BUFFER=2
		echo FB_MULTI_BUFFER=2
		./tiger -frameCount 300
		export FB_MULTI_BUFFER=1
		echo FB_MULTI_BUFFER=1
		./tiger -frameCount 300
		export FB_MULTI_BUFFER=0
		echo FB_MULTI_BUFFER=0
		./tiger -frameCount 300
		export FB_FRAMEBUFFER_0=/dev/fb1
		echo 0 > /sys/class/graphics/fb1/blank
		./tiger -frameCount 300
		echo 1 > /sys/class/graphics/fb1/blank
		echo 0 > /sys/class/graphics/fb0/blank
		export FB_FRAMEBUFFER_0=/dev/fb0
		
		RC=$?
		if [ $RC -eq 0 ]; then
			echo "TEST PASS"
		else
			echo "TEST FAIL"
	    fi
        return $RC
}
usage()
{
    echo "$0 [case ID]"
    echo "1: sequence test"
    echo "2: concurrent test"
    echo "3: conformance test"
    echo "4: pm test"
    echo "5: vgmark test"
    echo "6: FB MULTIBUFFER test"
}

# main function

RC=0

#TODO check parameter
if [ $# -ne 1 ]
then
    usage
    exit 1 
fi

TEST_DIR=/mnt/nfs/util/Graphics/

APP_SUB_DIR=

setup || exit $RC
#judge rootfs type
if [ -e /etc/X11 ];then
	APP_SUB_DIR="yocto_1.5_x/bin"
	export VIV_DESKTOP=0
	export DISPLAY=:0.0
	export LD_LIBRARY_PATH=$TEST_DIR/yocto_1.5_x/lib
elif [ -e /usr/lib/directfb-1.6-0 ];then
    echo "directfb rootfs"
elif [ -e /usr/lib/weston ];then
	APP_SUB_DIR="wayland"
else
	#judge the rootfs
    platfm.sh
    case "$?" in
    50)
        APP_SUB_DIR="imx50_rootfs/test"
        ;;
    41)
        APP_SUB_DIR="imx51_rootfs/test"
        ;;
    51)
        APP_SUB_DIR="imx51_rootfs/test"
        ;;
    53)
        APP_SUB_DIR="imx53_rootfs/test"
        ;;
    61)
        APP_SUB_DIR="imx61_rootfs/test"
        ;;
    63)
        APP_SUB_DIR="imx61_rootfs/test"
        ;;
    *)
        exit 0
        ;;
    esac
fi


case "$1" in
1)
    test_case_01 || exit $RC 
    ;;
2)
    test_case_02 || exit $RC
    ;;
3)
    test_case_03 || exit $RC
    ;;
4)
    test_case_04 || exit $RC
    ;;
5)
    test_case_05 || exit $RC
    ;;
6)
    test_case_06 || exit $RC
    ;;
*)
    usage
    ;;
esac

tst_resm TINFO "Test Finish"
