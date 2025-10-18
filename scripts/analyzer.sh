#!/bin/bash

# Simple tool to analyze pairs. Tested with bash 5.3.3
# Adds a new column FP/TP

infile="$1"
outfile="${infile}.analyzed"

[ -z "$infile" ] && { echo "Usage: $0 file.csv"; exit 1; }
[ ! -f "$infile" ] && { echo "File not found: $infile"; exit 1; }


while IFS=, read -r c1 c2 c3 c4 rest; do
    clear
    echo "$c1,$c2"
    echo "$c3,$c4"

    # read from /dev/tty so it actually waits for your input
    read -n1 -p "F or T? " ans < /dev/tty
    echo

    case "$ans" in
        F|f) tag="FP" ;;
        T|t) tag="TP" ;;
        *) tag="UNANALYSED" ;;
    esac

    echo "$c1,$c2,$c3,$c4${rest:+,$rest},$tag" >> "$outfile"
done < "$infile"
