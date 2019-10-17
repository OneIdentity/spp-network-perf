#!/bin/bash
# This is a script to support login files across multiple scripts
# It shouldn't be called directly.

check_ip_address()
{
    if ! [[ $1 =~ ^((1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$ ]]; then
        >&2 echo "'$1' must be a valid IP address"
        exit 1
    fi
}

convert_ip_address_to_int()
{
    local a b c d Ip=$@
    IFS=. read -r a b c d <<<"$Ip"
    printf '%d' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}

convert_int_to_ip_address()
{
    local Delim Exp Oct Ip Int=$@
    for Exp in {3..0}; do
        ((Oct = Int / (256 ** Exp)))
        ((Int -= Oct * 256 ** Exp))
        Ip+=$Delim$Oct
        Delim=.
    done
    printf '%s' "$Ip"
}

convert_mask_to_prefix()
{
    local dec bits=0
    IFS=.
    for dec in $1 ; do
        case $dec in
            255) bits=$((bits+=8));;
            254) bits=$((bits+=7));;
            252) bits=$((bits+=6));;
            248) bits=$((bits+=5));;
            240) bits=$((bits+=4));;
            224) bits=$((bits+=3));;
            192) bits=$((bits+=2));;
            128) bits=$((bits+=1));;
            0) ;;
            *) echo "Error: $dec is not recognized"; exit 1
        esac
    done
    echo "$bits"
}

sort_ip_list()
{
    local TempList IntList Ip Int
    for Ip in $(echo $1 | sed "s/,/ /g"); do
        IntList+="$(convert_ip_address_to_int $Ip),"
    done
    IntList=${IntList%,}
    IntList=$(echo $IntList | tr ',' '\n' | sort | tr '\n' ',');
    IntList=${IntList%,}
    for Int in $(echo $IntList | sed "s/,/ /g"); do
        TempList+="$(convert_int_to_ip_address $Int),"
    done
    TempList=${TempList%,}
    TempList=$(echo $TempList | sort | tr '\n' ',');
    echo ${TempList%,}
}

generate_ipv6_address()
{
    local quad1 quad2 a b c d Ip=$@
    IFS=. read -r a b c d <<<"$Ip"
    quad1=$(printf '%02X' $a $b)
    quad2=$(printf '%02X' $c $d)
    echo "fd70:616e:6761:6561:$quad1:$quad2:$quad1:$quad2"
}

get_count()
{
    local list=$1
    echo $list | awk -F',' '{print NF}'
}

# NOTE: this expects a one-based index
get_by_index()
{
    local list=$1
    local idx=$2
    local array
    IFS=, read -r -a array <<<"$list"
    idx=$((idx-=1))
    echo "${array[$idx]}"
}

# NOTE: this expects a one-based index
get_index_of()
{
    local list=$1
    local item=$2
    local array
    local idx
    IFS=, read -r -a array <<<"$list"
    local count=${#array[@]}
    count=$((count-=1))
    for i in $(seq 0 $count); do
        if [ "$item" = "${array[$i]}" ]; then
            idx=$((i+=1))
        fi
    done
    if [ -z "$idx" ]; then
        >&2 echo "No index found for '$item'"
    else
        echo $idx
    fi
}

