#!/bin/bash
FILE=$1
echo "False positives found:"
grep ",FP$" analyzed/libreoffice_core_analyzed.csv | cut -d ',' -f 1-12 | \
while IFS= read -r line; do
grep "$line" $FILE
done | wc -l

echo "True positives found:"
grep ",TP$" analyzed/libreoffice_core_analyzed.csv | cut -d ',' -f 1-12 | \
while IFS= read -r line; do
grep "$line" $FILE
done | wc -l
