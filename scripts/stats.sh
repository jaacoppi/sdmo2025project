#!/bin/bash

# Analysis scripts. 
# Takes a file name as argument. 
# Expectes the file to have column 13 as "FP" or "TP" indicating a  False or True positive

FILE=$1

echo "# c4-c7 True/False amounts and ratios"
echo "## False positives"
grep ",FP$" $1 \
| awk -F, '{t=f=0; for(i=1;i<=NF;i++){if($i=="True")t++; else if($i=="False")f++} print "Trues:",t,"Falses:",f}' \
| sort | uniq -c \
| awk '{count[$2" "$3" "$4" "$5]=$1; total+=$1} END{for(k in count) printf "%s %d (%.2f%%)\n", k, count[k], count[k]/total*100}'
echo ""
echo "## True positives"
grep ",TP$" $1 \
| awk -F, '{t=f=0; for(i=1;i<=NF;i++){if($i=="True")t++; else if($i=="False")f++} print "Trues:",t,"Falses:",f}' \
| sort | uniq -c \
| awk '{count[$2" "$3" "$4" "$5]=$1; total+=$1} END{for(k in count) printf "%s %d (%.2f%%)\n", k, count[k], count[k]/total*100}'

echo ""
echo ""

echo "# Which criteria C4-C7 are most often true/false in the sample?"
echo "## False positives"
grep ",FP$" $FILE | awk -F, '{for(i=9;i<=12;i++){if($i=="True")t[i]++; else if($i=="False")f[i]++}} END{for(i=9;i<=12;i++) printf "C%d → Trues: %d Falses: %d\n", i-5, t[i], f[i]}'
echo ""
echo "## True positives"
grep ",TP$" $FILE | awk -F, '{for(i=9;i<=12;i++){if($i=="True")t[i]++; else if($i=="False")f[i]++}} END{for(i=9;i<=12;i++) printf "C%d → Trues: %d Falses: %d\n", i-5, t[i], f[i]}'

echo ""
echo ""
echo "# Which patters are most common for False / True positive?"
echo "## False positives"
grep ",FP$" $FILE |  awk -F, '{
  pattern = $9","$10","$11","$12
  count[pattern]++
}
END{
  for(p in count) 
    print count[p], p
}' | sort -nr

echo ""
echo "## True positives"
grep ",TP$" $FILE |  awk -F, '{
  pattern = $9","$10","$11","$12
  count[pattern]++
}
END{
  for(p in count) 
    print count[p], p
}' | sort -nr
