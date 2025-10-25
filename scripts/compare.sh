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
echo "Checking which rows in $ANALYZED appear in $INPUT"
TOTALFP=$(grep ",FP$" $ANALYZED|wc -l)
TOTALTP=$(grep ",TP$" $ANALYZED|wc -l)

COUNTFP=$(compare "FP")
PERCENTAGEFP=$(echo "($COUNTFP/$TOTALFP)*100" |bc -l)
echo "False positives: $COUNTFP / $TOTALFP ($PERCENTAGEFP %)"

COUNTTP=$(compare "TP")
PERCENTAGETP=$(echo "($COUNTTP/$TOTALTP)*100" |bc -l)
echo "True positives: $COUNTTP / $TOTALTP ($PERCENTAGETP %)"
