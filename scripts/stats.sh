#!/bin/bash

# Analysis scripts. 

if [ "$#" -ne 2 ]; then
	echo "Usage: analyzedfile.csv threshold"
        echo "Analyzed file: file that has been manually analyzed, lines end with FP or TP as last column"
        echo "Threshold: Threshold parameter used when analyzed file was generated"
    exit 1
fi


FILE=$1
T=$2

amounts_ratios() {
TYPE=$1
grep ",$TYPE$" $FILE \
| awk -F, '{t=f=0; for(i=1;i<=NF;i++){if($i=="True")t++; else if($i=="False")f++} print "Trues:",t,"Falses:",f}' \
| sort | uniq -c \
| awk '{count[$2" "$3" "$4" "$5]=$1; total+=$1} END{for(k in count) printf "%s %d (%.2f%%)\n", k, count[k], count[k]/total*100}'
}

criteria_type_amounts() {
TYPE=$1
grep ",$TYPE$" $FILE | awk -F, '{for(i=9;i<=13;i++){if($i=="True")t[i]++; else if($i=="False")f[i]++}} END{for(i=9;i<=13;i++) printf "C%d → Trues: %d Falses: %d\n", i-5, t[i], f[i]}'

}

pattern_counts() {
TYPE=$1
grep ",$TYPE$" $FILE |  awk -F, '{
  pattern = $9","$10","$11","$12","$13
  count[pattern]++
}
END{
  for(p in count) 
    print count[p], p
}' | sort -nr
}


threshold_counts() {
TYPE=$1

grep ",$TYPE$" $FILE | awk -F, -v t=$2 '{
  c=0
  for(i=5;i<=8;i++)
    if($i+0 >= t) c++
  print "Cases with " c " criteria >= " t
}' | sort | uniq -c
}
threshold_counts $1 $2


echo "# c4-c8 True/False amounts and ratios"
echo "## False positives"
amounts_ratios "FP"
echo ""
echo "## True positives"
amounts_ratios "TP"

echo ""
echo ""

echo "# Which criteria C4-C8 are most often true/false in the sample?"
echo "## False positives"
criteria_type_amounts "FP"
echo ""
echo "## True positives"
criteria_type_amounts "TP"

echo ""
echo ""
echo "# Which patters are most common for False / True positive?"
echo "## False positives"
pattern_counts "FP"
echo ""
echo "## True positives"
pattern_counts "TP"


echo ""
echo ""
echo "# Threshold counts for t=$T"
echo "## False Positives"
threshold_counts "FP" "$T"
echo ""
echo ""
echo "## True Positives"
threshold_counts "TP" "$T"
