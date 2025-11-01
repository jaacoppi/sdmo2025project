# SDMO Course Project 1 (2025)

## Overview
In this project an improved version of Bird heuristics method implemented in [SDMO2025Project](https://github.com/M3SOulu/SDMO2025Project).
The purpose of this project is to figure out an improved solution to identify duplicate developers when mining repository commit data.

## Features
- Reads a CSV file of developers names and emails.
- Computes similarity between all developer pairs using Bird heuristics.
- Applies thresholds and filters to detect likely duplicates.
- Saves output as CSV with similarity scores and heuristics checks.

## Contents

- `inputs/`: Directory of example raw csv files mined from public github repositories.
- `analyzed/`: Csv files of analyzed results using the `project1developers.py` python script. Organized based on threshold.
- `scripts/`: Directory of bash scripts used to automate analysis processes.
- `tests/`: Directory containing unit tests for our implementation.
- `project1developers.py`: Script demonstrating Bird heurestic to determine duplicate developers.

## Requirements
Python version
- Python 3.10+ recommended

Requirements.txt
- Pandas
- Pytest
- Levenshtein

## Usage

After obtaining a .csv file with name and email columns (examples in inputs folder), it is run through the python file with required and optional arguments. After that you have a file which you can rename to a .csv file, which can be manually analyzed with the `analyzer.sh` script, where each pair can be marked as True Positive TP, or False Positive FP, by pressing F or T on the keyboard. Additional analysis on the data can be done using the other scripts located in the `scripts/` folder

### Required Arguments

| Flag | Description |
|------|-------------|
| `-i, --input` | Input CSV file with `name,email` pairs |
| `-t, --threshold` | Similarity threshold (0.0–1.0) |
| `-o, --output` | Output CSV file |

### Optional Arguments

| Flag | Description | Default |
|------|-------------|---------|
| `-m, --minimum-true-count` | Minimum number of heuristics checks to filter for | `3` |
| `-c, --criteria` | Comma-separated list of columns to evaluate for filtering | `c1_check,c2_check,c3_check,c4,c5,c6,c7,c8` |
| `-s, --sample-size` | Keep a random sample of N rows | `None` |
| `-n, --interval` | Keep every Nth row | `None` |

### Example run
#### Project1developers.py
```bash
python project1developers.py -i ./inputs/libreoffice_core.csv -t 0.5 -o ./libreoffice_core_analyzed.csv
```
#### Analyzer.sh
```bash
./analyzer.sh ./nextjs_t08.csv
```