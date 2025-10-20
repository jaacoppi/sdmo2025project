#!/bin/bash
# ANALYSED should be one of analyzed/*.csv
ANALYZED=$1
# INPUT should be a test case
INPUT=$2

compare() {
TYPE=$1
count=$(grep ",$TYPE$" $ANALYZED | cut -d ',' -f 1-12 |
while IFS= read -r line; do
grep -F "$line" $INPUT
done | wc -l)
echo -n "$count"
}
echo -n "False positives from $ANALYZED found in $INPUT:"
compare "FP"
echo ""

echo -n "True positives from $ANALYZED found in $INPUT:"
compare "TP"
echo ""
