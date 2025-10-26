#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Usage: inputfile.csv analyzedfile.csv threshold"
        echo "Input file: name+email pairs"
        echo "Analyzed file: file that has been manually analyzed, lines end with FP or TP as last column"
        echo "Threshold: Threshold parameter used when analyzed file was generated"
    exit 1
fi

ORIGINAL=$1
ANALYZED=$2
ANALYZED_THRESHOLD=$3

test_single_criteria() {
TEST_NUMBER=$1
ORIGINAL=$2
ANALYZED=$3
CRITERIA=$4
BASENAME=$(basename $ORIGINAL)
OUTPUT=testcase_${TEST_NUMBER}_${BASENAME}
python3 project1developers.py -i $ORIGINAL -o $OUTPUT -t $ANALYZED_THRESHOLD -c "$CRITERIA"
./scripts/compare.sh $ANALYZED $OUTPUT
}

test_c1_c2_t10() {
TEST_NUMBER=$1
ORIGINAL=$2
ANALYZED=$3
BASENAME=$(basename $ORIGINAL)
OUTPUT=testcase_${TEST_NUMBER}_${BASENAME}
python3 project1developers.py -i $ORIGINAL -o $OUTPUT -t 1.0 -c "c1,c2" -m 2
./scripts/compare.sh $ANALYZED $OUTPUT
}

test_thresholds() {
TEST_NUMBER=$1
ORIGINAL=$2
ANALYZED=$3
THRESHOLD=$4
BASENAME=$(basename $ORIGINAL)
OUTPUT=testcase_${TEST_NUMBER}_${BASENAME}
python3 project1developers.py -i $ORIGINAL -o $OUTPUT -t $THRESHOLD
./scripts/compare.sh $ANALYZED $OUTPUT
}

test_minimum_trues() {
TEST_NUMBER=$1
ORIGINAL=$2
ANALYZED=$3
MIN_TRUE=$4
BASENAME=$(basename $ORIGINAL)
OUTPUT=testcase_${TEST_NUMBER}_${BASENAME}
python3 project1developers.py -i $ORIGINAL -o $OUTPUT -t $ANALYZED_THRESHOLD -m $MIN_TRUE
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

echo "test case 7: Criteria C8 - equal emails"
test_single_criteria 7 $ORIGINAL $ANALYZED c8

echo "test case 8: Threshold 0.6"
test_thresholds 8 $ORIGINAL $ANALYZED 0.6

echo "test case 9: Threshold 0.7"
test_thresholds 9 $ORIGINAL $ANALYZED 0.7

echo "test case 10: Threshold 0.8"
test_thresholds 10 $ORIGINAL $ANALYZED 0.8

echo "test case 11: Threshold 0.9"
test_thresholds 11 $ORIGINAL $ANALYZED 0.9

echo "test case 12: Threshold 1.0"
test_thresholds 12 $ORIGINAL $ANALYZED 1.0

echo "test case 13: Criteria C1 && C2 1.0 - checks for domain changes"
test_c1_c2_t10 13 $ORIGINAL $ANALYZED

