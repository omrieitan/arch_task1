#!/bin/bash

echo -e "\e[1m_________STARTING TEST_________\e[0m"
echo ""
NUM1="$(( ( $RANDOM % 100 )  + 1 ))"
NUM2="$(( ( $RANDOM % 100 )  + 1 ))"
echo "test $NUM1 + $NUM2 ="
CORRECT="$(./bin/calc <<< $NUM1' '$NUM2' +')"
TEST="$(dc <<< $NUM1' '$NUM2' +pq')"

if [ "$CORRECT" != "$TEST" ];
    then
    echo -e "\e[41mFAILED\e[49m"
    echo -e "\e[41mexpected: "$CORRECT"\e[49m"
    echo -e "\e[41mgot: "$TEST"\e[49m"
    else
    echo -e "\e[92mPASSED\e[39m"
fi
