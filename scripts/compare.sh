#!/bin/bash
# ANALYSED should be one of analyzed/*.csv
ANALYZED=$1
# INPUT should be a test case
INPUT=$2
echo "False positives from $ANALYZED found in $INPUT:"
grep ",FP$" $ANALYZED | cut -d ',' -f 1-12 | \
while IFS= read -r line; do
grep "$line" $INPUT
done | wc -l

echo "True positives from $ANALYZED found in $INPUT:"
grep ",TP$" $ANALYZED | cut -d ',' -f 1-12 | \
while IFS= read -r line; do
grep "$line" $INPUT
done | wc -l
