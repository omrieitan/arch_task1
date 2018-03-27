#!/bin/bash

MUN_OF_TESTS=10
PATH_TO_PROGRAM="./bin/calc"

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
function bignum_medium(){
    local  num=""
    if [ $(($RANDOM%2)) == 1 ];
        then num="_"
    fi
    num+="$(( ( $RANDOM % 9 ) +1 ))"
    for ((number=1;number < $(( ( $RANDOM % 80 )  + 1 ));number++))
    {
        num+="$(( ( $RANDOM % 9 ) ))"
    }
    echo $num
}
function bignum_small(){
    local  num=""
    if [ $(($RANDOM%2)) == 1 ];
        then num="_"
    fi
    num+="$(( ( $RANDOM % 9 ) +1 ))"
    for ((number=1;number < $(( ( $RANDOM % 60 )  + 1 ));number++))
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
function rand_muldiv(){
local  sign="$(($RANDOM%2))"
case "$sign" in
       0) 
        echo "*"
        ;;
       1) 
        echo "/"
        ;;
esac
}
function rand_all(){
local  sign="$(($RANDOM%4))"
case "$sign" in
       0) 
        echo "+"
        ;;
       1) 
        echo "-"
        ;;
       2) 
        echo "*"
        ;;
       3) 
        echo "/"
        ;;
esac
}

echo -e "\e[1m _____         _    _   _____         _   "
echo -e "|_   _|_ _ ___| | _/ | |_   _|__  ___| |_ "
echo -e "  | |/ _  / __| |/ / |   | |/ _ \/ __| __|"
echo -e "  | | (_| \__ \   <| |   | |  __/\__ \ |_ "
echo -e "  |_|\__,_|___/_|\_\_|   |_|\___||___/\__|"
echo ""
NUM_OF_TESTS_FAILED=0


while [ ! $# -eq 0 ]
do
	case "$1" in
		--add | -a)
			{ # add test
echo ""
echo -e "\e[4m\e[1mADD OPERATION\e[0m"
counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
    NUM1=$(bignum)
    NUM2=$(bignum)
    
    echo -e "\e[4mtest$counter\e[0m: $NUM1 + $NUM2 ="
    TEST="$($PATH_TO_PROGRAM <<< $NUM1' '$NUM2' +')"
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
}
			;;
		--sub | -b)
			{ # sub test
echo ""
echo -e "\e[4m\e[1mSUB OPERATION\e[0m"
counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
    NUM1=$(bignum)
    NUM2=$(bignum)
    
    echo -e "\e[4mtest$counter\e[0m: $NUM1 - $NUM2 ="
    TEST="$($PATH_TO_PROGRAM <<< $NUM1' '$NUM2' -')"
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
}			;;
                --add_sub | -c)
                        { # add&sub test
echo ""
echo -e "\e[4m\e[1mADD&SUB OPERATIONS\e[0m"
counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
ARG="$(bignum_medium) $(bignum_medium) $(rand_sign)"
for ((number=1;number < $(( ( $RANDOM % 20 )  + 1 ));number++))
    {
    if [ $(($RANDOM%2)) == 1 ];
        then ARG+=" $(bignum_medium) $(rand_sign)"
        else ARG+=" $(bignum_medium) $(bignum_medium) $(rand_sign) $(rand_sign)"
    fi
    }
echo -e "\e[4mtest$counter\e[0m: $ARG"
    TEST="$($PATH_TO_PROGRAM <<< $ARG)"
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
    ((counter++))
done
}
                        ;;
                --mul | -d)
			{ # mul test
echo ""
echo -e "\e[4m\e[1mMUL OPERATION\e[0m"
counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
    NUM1=$(bignum_medium)
    NUM2=$(bignum_medium)
    
    echo -e "\e[4mtest$counter\e[0m: $NUM1 * $NUM2 ="
    TEST="$($PATH_TO_PROGRAM <<< $NUM1' '$NUM2' *')"
    CORRECT="$(dc <<< $NUM1' '$NUM2' *pq')"

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
}
                        ;;
                --div | -e)
			{ # div test
echo ""
echo -e "\e[4m\e[1mDIV OPERATION\e[0m"
counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
    NUM1=$(bignum)
    NUM2=$(bignum)
    
    echo -e "\e[4mtest$counter\e[0m: $NUM1 / $NUM2 ="
    TEST="$($PATH_TO_PROGRAM <<< $NUM1' '$NUM2' /')"
    CORRECT="$(dc <<< $NUM1' '$NUM2' /pq')"

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
}
                        ;;
                --mul_div | -f)
                        { # mul&div test
echo ""
echo -e "\e[4m\e[1mMUL&DIV OPERATIONS\e[0m"
counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
ARG="$(bignum_small) $(bignum_small) $(rand_muldiv)"
for ((number=1;number < $(( ( $RANDOM % 15 )  + 1 ));number++))
    {
    if [ $(($RANDOM%2)) == 1 ];
        then ARG+=" $(bignum_small) $(rand_muldiv)"
        else ARG+=" $(bignum_small) $(bignum_small) $(rand_muldiv) $(rand_muldiv)"
    fi
    }
echo -e "\e[4mtest$counter\e[0m: $ARG"
    TEST="$($PATH_TO_PROGRAM <<< $ARG)"
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
    ((counter++))
done
}
                        ;;
                --all | -g)
                        { # all together test
echo ""
echo -e "\e[4m\e[1mALL OPERATIONS\e[0m"
counter=1
while [ $counter -le $MUN_OF_TESTS ]
do
ARG="$(bignum_medium) $(bignum_medium) $(rand_all)"
for ((number=1;number < $(( ( $RANDOM % 20 )  + 1 ));number++))
    {
    if [ $(($RANDOM%2)) == 1 ];
        then ARG+=" $(bignum_medium) $(rand_all)"
        else ARG+=" $(bignum_medium) $(bignum_medium) $(rand_all) $(rand_all)"
    fi
    }
echo -e "\e[4mtest$counter\e[0m: $ARG"
    TEST="$($PATH_TO_PROGRAM <<< $ARG)"
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
    ((counter++))
done
}
                        ;;
                --help | -h)
                        {
echo ""
echo -e "\e[4m\e[1mLIST OF FLAGS\e[0m"
echo "    --add OR -a     : for tests of single add operation
    --sub OR -b     : for tests of single sub operation
    --add_sub OR -c : for tests of multiple add and sub operations
    --mul OR -d     : for tests of single mul operation
    --div OR -e     : for tests of single div operation
    --mul_div OR -f : for tests of multiple mul and div operations
    --all OR -g     : for tests of multiple operations of all kinds
    --help OR -h    : for help (and all following flags will be ignored)
    
* made to run on linux.
* uses the dc command for comparation.
* numbers, operations and their order are generated randomly each time."
                }
                exit 1
                        ;;
                *) echo -e "\e[91mInvalid option: $*\e[0m"
                   exit 1
                        ;;
	esac
	shift
done


if [ "$NUM_OF_TESTS_FAILED" == 0 ];
    then echo ""
    echo -e "\e[42mPASSED ALL TESTS, WELL DONE =]\e[49m"
    else echo ""
    echo -e "\e[1m\e[41mFailed "$NUM_OF_TESTS_FAILED" tests.\e[0m"
fi


# 01101101011000010110010001100101001000000110001001111001001000000100111101101101011100100110100100100000010001010110100101110100011000010110111000001101