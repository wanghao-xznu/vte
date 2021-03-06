#!/bin/bash

setup()
{
    # Total number of test cases in this file. 
    export TST_TOTAL=1

    # The TCID and TST_COUNT variables are required by the LTP 
    # command line harness APIs, these variables are not local to this program.

    # Test case identifier
    export TCID="wifi_POWER_test"
    # Set up is initialized as test 0
    export TST_COUNT=0
    # Initialize cleanup function to execute on program exit.
    # This function will be called before the test program exits.
    trap "cleanup" 0

	if [ -z "$SERVERIP" ]; then
    	export SERVERIP=10.192.244.7
	fi
    modprobe ar6000
    sleep 5
    iwconfig wlan0 mode managed && sleep 10 && iwlist wlan0 scanning | grep MAD-wifi && iwconfig wlan0 key 00112233445566778899123456 && iwconfig wlan0 essid MAD-wifi
    if [ $? -ne 0 ];then
        RC=1
    else
        udhcpc -i wlan0
        sleep 3
        localip=$(ifconfig wlan0 | grep addr: | cut -d : -f 2 | cut -d " " -f 1)
        export LOCALIP=${localip}
        route add -host $SERVERIP dev wlan0
    fi


    return $RC
}

cleanup()
{
    echo "CLEANUP "
    route del -host $SERVERIP dev wlan0
    route del default dev wlan0
    modprobe -r ar6000
}

usage()
{
    echo "1: for device suspend resume case for no boot cores "	
    echo "2: for device suspend resume case for all cores "	
}

# Function:     test_case_01
# Description   - Test if device suspend and resume without bootcore
#  
test_case_01()
{
    #TODO give TCID 
    TCID="wifi_PM_NOBOOTCORE"
    #TODO give TST_COUNT
    TST_COUNT=1
    RC=1

    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "

    #TODO add function test scripte here
    udp_stream_2nd_script ${SERVERIP} CPU &

    sleep 5
    echo "core test"
    i=0
    loops=10
    echo core > /sys/power/pm_test
    while [ $i -lt $loops ]
    do
        i=$(expr $i + 1)
        echo mem > /sys/power/state
        echo standby > /sys/power/state
    done

    sleep 30
    echo none > /sys/power/pm_test

    wait

    RC=0

    return $RC

}

# Function:     test_case_02
# Description   - Test if device suspend and resume without bootcore
#  
test_case_02()
{
    #TODO give TCID 
    TCID="wifi_PM_BOOTCORE"
    #TODO give TST_COUNT
    TST_COUNT=1
    RC=1

    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
    tloops=100
    count=0
    #TODO add function test scripte here
    while [ $count -lt $tloops ]
    do

        udp_stream_2nd_script ${SERVERIP} CPU &

        sleep 5
        i=0
        loops=100
        while [ $i -lt $loops ]
        do
            i=$(expr $i + 1)
            rtc_testapp_6 -T 50 -m mem
            rtc_testapp_6 -T 50 -m standby
        done

        wait

        count=$(expr $count + 1)
    done

    RC=0

    return $RC

}

# Function:     test_case_03
# Description   - Test if device suspend and resume without bootcore
#  
test_case_03()
{
    #TODO give TCID 
    TCID="wifi_PM_WAITMODE"
    #TODO give TST_COUNT
    TST_COUNT=1
    RC=1

    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "

    #TODO add function test scripte here
    udp_stream_2nd_script ${SERVERIP} CPU &

    sleep 5
    echo "core test"
    i=0
    loops=10
    echo core > /sys/power/pm_test
    while [ $i -lt $loops ]
    do
        i=$(expr $i + 1)
        echo standby > /sys/power/state
    done

    sleep 30
    echo none > /sys/power/pm_test

    wait

    RC=0

    return $RC

}



setup || exit 1

case "$1" in
1)
    test_case_01 || exit 2 
    ;;
2)
    test_case_02 || exit 3
    ;;
3)
    test_case_03 || exit 3
    ;;
*)
    usage
    ;;
esac

tst_resm TINFO "Test Finish"
