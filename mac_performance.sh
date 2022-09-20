#!/bin/sh

##############
# Parameters #
##############

log_path='/var/log/performance.log'
n_cycles=3
interval_s=2
now=$(date +'%Y-%m-%d_%H:%M')



###################
# Check save path #
###################

log_dir=$(dirname $log_path)

if [ ! -d $log_dir ]; then
    echo ERROR: Directory $log_dir does not exist! Exiting script!
    exit 1
fi

if [ ! -w $log_dir ]; then
    echo ERROR: Directory $log_dir is not writeable!\\n\
    Please check if you have necessary permissions or change log_path!\\n\
    Exiting script!
    exit 1
fi



echo =====START_SESSION_$now===== >> $log_path



##########################
# Get power/battery info #
##########################

echo Collecting battery info:

echo -----START_BATTERY_INFO----- >> $log_path

echo -----START_SYSTEMWIDE_POWER_SETTINGS----- >> $log_path
pmset -g live >> $log_path
echo -----END_SYSTEMWIDE_POWER_SETTINGS-----\\n\\n >> $log_path

echo -----START_SYSTEM_POWER_STATE----- >> $log_path
pmset -g systemstate >> $log_path
echo -----END_SYSTEM_POWER_STATE-----\\n\\n >> $log_path

echo -----START_DRIVERS_POWER_STATE----- >> $log_path
pmset -g powerstate >> $log_path
echo -----END_DRIVERS_POWER_STATE-----\\n\\n >> $log_path

echo -----START_USER_ACTIVITY----- >> $log_path
pmset -g useractivity >> $log_path
echo -----END_USER_ACTIVITY-----\\n\\n >> $log_path

echo -----START_SYSLOAD_ADVISORY----- >> $log_path
pmset -g sysload >> $log_path
echo -----END_SYSLOAD_ADVISORY-----\\n\\n >> $log_path

echo -----START_THERMAL_SPEED_LIMITS----- >> $log_path
pmset -g therm >> $log_path
echo -----END_THERMAL_SPEED_LIMITS-----\\n\\n >> $log_path

echo -----START_RAW_BATTERY_INFO----- >> $log_path
pmset -g rawbatt >> $log_path
echo -----END_RAW_BATTERY_INFO-----\\n\\n >> $log_path

echo -----START_BATTERY_STATUS----- >> $log_path
pmset -g ps >> $log_path
echo -----END_BATTERY_STATUS-----\\n\\n >> $log_path

echo -----START_ADAPTER_STATUS----- >> $log_path
pmset -g adapter >> $log_path
echo -----END_ADAPTER_STATUS-----\\n\\n >> $log_path

echo -----END_BATTERY_INFO-----\\n\\n\\n\\n\\n >> $log_path

echo Battery info saved to $log_path\\n



#################
# Get disk info #
#################

echo Collecting disk info

echo -----START_DISK_INFO----- >> $log_path
diskutil info -all >> $log_path
echo -----END_DISK_INFO-----\\n\\n\\n\\n\\n >> $log_path

echo Disk info saved to $log_path\\n



################
# Get top data #
################

echo Collecting processes info: $n_cycles cycles with an interval of $interval_s seconds.

echo -----START_TOP_INFO----- >> $log_path

i=0
while [ $i -lt $n_cycles ]
do
    echo -----START_TOP_CYCLE_$(($i+1))----- >> $log_path
    top -o mem -l 1 >> $log_path
    echo -----END_TOP_CYCLE_$(($i+1))-----\\n\\n\\n >> $log_path
    echo Completed cycle $(($i+1)) of $n_cycles
    sleep $interval_s
    i=$((i+1))
done

echo -----END_TOP_INFO-----\\n\\n\\n\\n\\n >> $log_path

echo Processes info saved to $log_path\\n



echo =====END_SESSION_$now===== >> $log_path
echo Script finished, info saved to $log_path
exit 0
