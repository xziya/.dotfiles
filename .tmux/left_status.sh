#!/bin/bash


function ip_address() {

    # Loop through the interfaces and check for the interface that is up.
    # for file in /sys/class/net/*; do

    #     iface=$(basename $file);

    #     read status < $file/operstate;

    #     [ "$status" == "up" ] && ip addr show $iface | awk '/inet /{printf $2" "}'

    # done

    # Loop through the interfaces and check for the one that is up.
    for iface in /sys/class/net/en*/operstate; do
        if [ "$(echo $iface | awk -F'/' '{print $5}')" != "lo" ]; then
            if [ "$(cat $iface)" == "up" ] ; then
                interface=$(echo $iface | awk -F'/' '{print $5}')
                printf "%s " "$(ip addr show $interface | awk '/inet /{print $2}')"
            fi
        fi
    done
}

function cpu_temperature() {

    # Display the temperature of CPU core 0 and core 1.
    sensors | awk '/Package id 0/{printf $4" "}'

}

function memory_usage() {

    if [ "$(which bc)" ]; then

        # Display used, total, and percentage of memory using the free command.
        read used total <<< $(free -m | awk '/Mem/{printf $2" "$3}')
        # Calculate the percentage of memory used with bc.
        percent=$(bc -l <<< "100 * $total / $used")
        usedG=$(bc -l <<< "$used / 1024")
        totalG=$(bc -l <<< "$total / 1024")
        # Feed the variables into awk and print the values with formating.
        awk -v u=$usedG -v t=$totalG -v p=$percent 'BEGIN {printf "mem:%.1f% ", p}'

    fi

}

function gpu_usage() {
    if [ "$(which nvidia-smi)" ]; then
        printf "%s" "cu@"
        read mb_used unit <<< "$(nvidia-smi --query-gpu="memory.used" --format=csv,noheader)"
        gb_used=$(bc -l <<< "$mb_used / 1024")
        read gpu_utilization <<< "$(nvidia-smi --query-gpu 'utilization.gpu' --format=csv,noheader | tr -d ' ')"
        printf "%s:%.1fG" "${gpu_utilization}" "${gb_used}"
    fi

    # [ "$(which nvidia-smi)" ] && printf "%s" "$(nvidia-smi --query-gpu 'utilization.gpu,utilization.memory' --format=csv,noheader | tr -d ' ')"
}

function vpn_connection() {

    # Check for tun0 interface.
    [ -d /sys/class/net/tun0 ] && printf "%s " 'VPN*'

}

function main() {

    # Comment out any function you do not need.
    # ip_address
    cpu_temperature
    memory_usage
    # vpn_connection
    gpu_usage

}

# Calling the main function which will call the other functions.
main
