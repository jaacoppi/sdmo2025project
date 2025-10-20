#!/bin/bash
# example: tests/run_tests inputs/libreoffice_core.csv analyzed/libreoffice_core_analyzed.csv

ORIGINAL=$1
ANALYZED=$2

test_minimum_trues() {
TEST_NUMBER=$1
ORIGINAL=$2
ANALYZED=$3
MIN_TRUE=$4
BASENAME=$(basename $ORIGINAL)
OUTPUT=testcase_${TEST_NUMBER}_${BASENAME}
python3 project1developers.py -i $ORIGINAL -o $OUTPUT -t 1.0 -m $MIN_TRUE
./scripts/compare.sh $ANALYZED $OUTPUT
}

echo "test case 1: minimum true count 2"
test_minimum_trues 1 $ORIGINAL $ANALYZED 2

echo "test case 2: minimum true count 3"
test_minimum_trues 2 $ORIGINAL $ANALYZED 3

echo "test case 3: minimum true count 4"
test_minimum_trues 3 $ORIGINAL $ANALYZED 4

echo "test case 4: minimum true count 5"
test_minimum_trues 4 $ORIGINAL $ANALYZED 5

echo "test case 5: minimum true count 6"
test_minimum_trues 5 $ORIGINAL $ANALYZED 6

echo "test case 6: minimum true count 7"
test_minimum_trues 6 $ORIGINAL $ANALYZED 7
