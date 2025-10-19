#!/bin/bash
ANALYZED=$1

echo "test case 1: minimum true count 2"
python3 project1developers.py -i $ANALYZED -o testcase1_${ANALYZED}.csv -t 1.0 -m 2
../scripts/compare.sh $ANALYZEZD testcase1_${ANALYZED}.csv

echo "test case 2: minimum true count 3"
python3 project1developers.py -i $ANALYZED -o testcase1_${ANALYZED}.csv -t 10 -m 3
../scripts/compare.sh $ANALYZEZD testcase2_${ANALYZED}.csv

echo "test case 3: minimum true count 4"
python3 project1developers.py -i $ANALYZED -o testcase1_${ANALYZED}.csv -t 1.0 -m 4
../scripts/compare.sh $ANALYZEZD testcase3_${ANALYZED}.csv

echo "test case 4: minimum true count 5"
python3 project1developers.py -i $ANALYZED -o testcase1_${ANALYZED}.csv -t 1.0 -m 5
../scripts/compare.sh $ANALYZEZD testcase4_${ANALYZED}.csv

echo "test case 5: minimum true count 6"
python3 project1developers.py -i $ANALYZED -o testcase1_${ANALYZED}.csv -t 1.0 -m 6
../scripts/compare.sh $ANALYZEZD test5ase3_${ANALYZED}.csv

echo "test case 5: minimum true count 7"
python3 project1developers.py -i $ANALYZED -o testcase1_${ANALYZED}.csv -t 1.0 -m 7
../scripts/compare.sh $ANALYZEZD testcase6_${ANALYZED}.csv
