"""
This project is for University of Oulu SDMO course in 2025.

The tool implements Bird heuristics for detecting unique individuals from git commits
"""

import argparse
import csv
import os
from itertools import combinations
import string
import unicodedata
from Levenshtein import ratio as sim
import pandas as pd


def select_criteria(df, minimum_trues, true_columns):
    """ Selet criteria for filtering results """
    # Filter columns that match the criteria
    print("Filtering criteria:")
    print(f"Mminimum true count: {minimum_trues}")
    print(f"True criteria: {true_columns}")
    df = df[(df[true_columns].sum(axis=1) >= minimum_trues) | (df["c8"]) | ((df["c1"] == 1.0) & (df["c2"] == 1.0))]

    return df

def create_arguments():
    """ handle command line arguments """
    parser = argparse.ArgumentParser(description="Bird heuristics analyser")

    required_group = parser.add_argument_group("Required arguments")
    required_group.add_argument("-i", "--input", type=str, help="name+email pairs as comma-delimited csv", required=True)
    required_group.add_argument("-t", "--threshold", type=float, help="Threshold from 0.0 to 1.0", required=True)
    required_group.add_argument("-o", "--output", type=str, help="Output file", required=True)

    optional_group = parser.add_argument_group("Optional arguments")
    optional_group.add_argument("-m", "--minimum-true-count", type=int, help="Minimum amount of trues to be filtered for (Default: 1)", default=3)
    optional_group.add_argument("-c", "--criteria", type=str, help="Comma-separated list of columns to evaluate (e.g. 'c1_check,c2_check,c3_check')", default="c1_check,c2_check,c3_check,c4,c5,c6,c7,c8")
    optional_group.add_argument("-s", "--sample-size", type=int, help="Leave a random sample of N rows")
    optional_group.add_argument("-n", "--interval", type=int, help="Leave every Nth row")

    return parser.parse_args()

def read_devs(input_file):
    """ This block of code reads an existing csv of developers """
    devs = []
    # Read csv file with name,dev columns
    with open(input_file, 'r', newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            devs.append(row)
    # First element is header, skip
    devs = devs[1:]

    return devs

def process(dev):
    """ Function for pre-processing each name,email """
    name: str = dev[0]

    # Remove punctuation
    trans = name.maketrans("", "", string.punctuation)
    name = name.translate(trans)
    # Remove accents, diacritics
    name = unicodedata.normalize('NFKD', name)
    name = ''.join([c for c in name if not unicodedata.combining(c)])
    # Lowercase
    name = name.casefold()
    # Strip whitespace
    name = " ".join(name.split())


    # Attempt to split name into firstname, lastname by space
    parts = name.split(" ")
    # Expected case
    if len(parts) == 2:
        first, last = parts
    # If there is no space, firstname is full name, lastname empty
    elif len(parts) == 1:
        first, last = name, ""
    # If there is more than 1 space, firstname is until first space, rest is lastname
    else:
        first, last = parts[0], " ".join(parts[1:])

    # Take initials of firstname and lastname if they are long enough
    i_first = first[0] if len(first) > 1 else ""
    i_last = last[0] if len(last) > 1 else ""

    # Determine email prefix
    email: str = dev[1]
    prefix = email.split("@")[0]

    return name, first, last, i_first, i_last, email, prefix

def compute_similarity(devs):
    """ Compute similarity between all possible pairs """
    similarity = []
    for dev_a, dev_b in combinations(devs, 2):
        # Pre-process both developers
        name_a, first_a, last_a, i_first_a, i_last_a, email_a, prefix_a = process(dev_a)
        name_b, first_b, last_b, i_first_b, i_last_b, email_b, prefix_b = process(dev_b)

        # Conditions of Bird heuristic
        c1 = sim(name_a, name_b)
        c2 = sim(prefix_b, prefix_a)
        c31 = sim(first_a, first_b)
        c32 = sim(last_a, last_b)
        c4 = c5 = c6 = c7 = c8 = False
        # Since lastname and initials can be empty, perform appropriate checks
        if i_first_a != "" and last_a != "":
            c4 = i_first_a in prefix_b and last_a in prefix_b
        if i_last_a != "":
            c5 = i_last_a in prefix_b and first_a in prefix_b
        if i_first_b != "" and last_b != "":
            c6 = i_first_b in prefix_a and last_b in prefix_a
        if i_last_b != "":
            c7 = i_last_b in prefix_a and first_b in prefix_a
        if email_a == email_b:
            c8 = True

        # Save similarity data for each conditions. Original names are saved
        similarity.append([dev_a[0], email_a, dev_b[0], email_b, c1, c2, c31, c32, c4, c5, c6, c7, c8])

    return similarity

def save_data_on_all_pairs(similarity):
    """ Save data on all pairs (might be too big -> comment out to avoid) """
    cols = ["name_1", "email_1", "name_2", "email_2", "c1", "c2",
            "c3.1", "c3.2", "c4", "c5", "c6", "c7", "c8"]
    df = pd.DataFrame(similarity, columns=cols)
    df.to_csv("devs_similarity.csv", index=False, header=True)

    return df

def set_similarity(df, minimum_trues, true_columns):
    """ Set similarity threshold, check c1-c3 against the threshold """
    print("Threshold:", threshold)
    df["c1_check"] = df["c1"] >= threshold
    df["c2_check"] = df["c2"] >= threshold
    df["c3_check"] = (df["c3.1"] >= threshold) & (df["c3.2"] >= threshold)
    df = select_criteria(df, minimum_trues, true_columns)

    return df

def omit_check_and_save(df, output_file):
    """  Omit "check" columns, save to csv """
    df = df[["name_1", "email_1", "name_2", "email_2", "c1", "c2",
        "c3.1", "c3.2", "c4", "c5", "c6", "c7", "c8"]]
    df.to_csv(os.path.join(output_file), index=False, header=True)

    return df

def post_process(df):
    """ Filter for sample or interval """
    if args.sample_size:
        sampled_df = df.sample(n=args.sample_size, random_state=42)
        sampled_file = os.path.join("project1devs", f"devs_similarity_sampled_{args.sample_size}.csv")
        sampled_df.to_csv(sampled_file, index=False, header=True)
        print(f"Random sample of {args.sample_size} rows saved to {sampled_file}")

    elif args.interval:
        interval_df = df.iloc[::args.interval]
        interval_file = os.path.join("project1devs", f"devs_similarity_every_{args.interval}th.csv")
        interval_df.to_csv(interval_file, index=False, header=True)
        print(f"Every {args.interval}th row saved to {interval_file}")

# MAIN
args = create_arguments()

# Get file names from command line arguments
input_file = args.input
output_file = args.output
threshold = args.threshold
minimum_trues= args.minimum_true_count
true_columns = [c.strip() for c in args.criteria.split(",")]

# Run everything
developers = read_devs(input_file)
similarity = compute_similarity(developers)
df_all_pairs = save_data_on_all_pairs(similarity)
df_with_threshold_check = set_similarity(df_all_pairs, minimum_trues, true_columns)
df_final = omit_check_and_save(df_with_threshold_check, output_file)
post_process(df_final)
