#!/bin/bash
OLD=$1
NEW=$2

awk -F, 'NR==FNR {
    key = ""
    for(i=1;i<=12;i++) key = key $i  # build key from cols 1–12
    keys[++n] = key
    foo[key] = $0
    next
}
{
    key = ""
    for(i=1;i<=12;i++) key = key $i
    bar13[key] = $13
}
END {
    for(i=1;i<=n;i++) {
        k = keys[i]
        if(k in bar13) {
            split(foo[k], f, ",")
            out = ""
            for(j=1;j<=12;j++) out = out f[j] ","
            out = out bar13[k]  # insert bar col13
            for(j=13;j<=length(f);j++) out = out "," f[j]  # append rest of foo starting at its original col13
            print out
        }
    }
}' $OLD $NEW > merged.txt
