#!/bin/bash

MUN_OF_TESTS=10
NUM_OF_TESTS_FAILED=0

function bignum(){
    local  num=""
    if [ $(($RANDOM%2)) == 1 ];
        then num="_"
    fi
    num+="$(( ( $RANDOM % 9 ) +1 ))"
    for ((number=1;number < $(( ( $RANDOM % 300 )  + 1 ));number++))
    {
        num+="$(( ( $RANDOM % 9 ) ))"
    }
    echo $num
}
function rand_sign(){
local  sign=""
if [ $(($RANDOM%2)) == 1 ];
        then sign="-"
        else sign="+"
    fi
    echo $sign
}

echo -e "\e[1m_________TASK1 TEST_________\e[0m"
echo ""

echo -e "\e[1mADD OPERATION_________\e[0m"

counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
    NUM1=$(bignum)
    NUM2=$(bignum)
    
    echo "test$counter: $NUM1 + $NUM2 ="
    TEST="$(./bin/calc <<< $NUM1' '$NUM2' +')"
    CORRECT="$(dc <<< $NUM1' '$NUM2' +pq')"

    if [ "$CORRECT" != "$TEST" ];
        then
        echo -e "\e[41mFAILED\e[49m"
        echo -e "\e[41mexpected: "$CORRECT"\e[49m"
        echo -e "\e[41m     got: "$TEST"\e[49m"
        ((NUM_OF_TESTS_FAILED++))
        else
        echo -e "\e[92mPASSED\e[39m"
    fi
    ((counter++))
done

echo ""
echo -e "\e[1mSUB OPERATION_________\e[0m"

counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
    NUM1=$(bignum)
    NUM2=$(bignum)
    
    echo "test$counter: $NUM1 - $NUM2 ="
    TEST="$(./bin/calc <<< $NUM1' '$NUM2' -')"
    CORRECT="$(dc <<< $NUM1' '$NUM2' -pq')"

    if [ "$CORRECT" != "$TEST" ];
        then
        echo -e "\e[41mFAILED\e[49m"
        echo -e "\e[41mexpected: "$CORRECT"\e[49m"
        echo -e "\e[41m     got: "$TEST"\e[49m"
        ((NUM_OF_TESTS_FAILED++))
        else
        echo -e "\e[92mPASSED\e[39m"
    fi
    ((counter++))
done

echo ""
echo -e "\e[1mADD&SUB OPERATIONS_____\e[0m"

ARG="$(bignum) $(bignum) $(rand_sign)"
for ((number=1;number < $(( ( $RANDOM % 20 )  + 1 ));number++))
    {
        ARG+=" $(bignum) $(rand_sign)"
    }
echo "test$counter: $ARG"
    TEST="$(./bin/calc <<< $ARG)"
    CORRECT="$(dc <<< $ARG' pq')"

    if [ "$CORRECT" != "$TEST" ];
        then
        echo -e "\e[41mFAILED\e[49m"
        echo -e "\e[41mexpected: "$CORRECT"\e[49m"
        echo -e "\e[41m     got: "$TEST"\e[49m"
        ((NUM_OF_TESTS_FAILED++))
        else
        echo -e "\e[92mPASSED\e[39m"
    fi


if [ "$NUM_OF_TESTS_FAILED" == 0 ];
    then
    echo -e "\e[42mPASSED ALL TESTS, WELL DONE =]\e[49m"
    else
    echo -e "\e[41mFailed "$NUM_OF_TESTS_FAILED" tests.\e[49m"
fi


