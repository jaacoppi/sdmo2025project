import pytest
import csv
import pandas as pd
from pathlib import Path

from project1developers import read_devs, process, select_criteria

TESTS_DIR = Path(__file__).parent

def test_read_devs_return():
    """ Ensure read_devs reads all rows and skips the header """
    sample_csv = TESTS_DIR / "read_devs_input.csv" 
    actual = read_devs(sample_csv)
    expected = [
        ["erkki peltonen", "erkki.peltonen@gmail.com"],
        ["jakub", "jakub@school.warsaw.pl"],
        ["santeri5473", "5473@gratud.com"],
        ["päivi pölkynen", "päivi.pölkkynen@users.noreply.github.com"]
    ]
    assert actual == expected

def test_read_devs_empty_file():
    """ Ensure function handles a CSV with only the header"""
    empty_csv = TESTS_DIR / "read_devs_onlyheader.csv"
    actual = read_devs(empty_csv)
    assert actual == []

def test_process():
    """ Test that name and email pairs are processed / standardized for similarity testing """
    # TODO: use dataclass Dev here

    dev = ["Testiina de Téstirsson", "testiina@testirsson.com"]
    name, first, last, i_first, i_last, email, prefix = process(dev)
    assert name == "testiina de testirsson"
    assert first == "testiina"
    assert last == "de testirsson"
    assert i_first == "t"
    assert i_last == "d"
    assert email == "testiina@testirsson.com"
    assert prefix == "testiina"

    dev2 = ["Virtanen, Matti", "matti.virtanen@suomi.fi"]
    name2, first2, last2, i_first2, i_last2, email2, prefix2 = process(dev2)
    assert name2 == "virtanen matti"
    assert first2 == "virtanen"
    assert last2 == "matti"
    assert i_first2 == "v"
    assert i_last2 == "m"
    assert email2 == "matti.virtanen@suomi.fi"
    assert prefix2 == "matti.virtanen"

   

def test_select_criteria():
    """ Test that correct rows are filtered out """
    # Create a test dataframe
    df = pd.DataFrame([
        # row 0: All true, should always pass
        {"c1": 1.0, "c2": 1.0, "c3": 1.0, "c1_check": True, "c2_check": True, "c3_check": True, "c4": True, "c5": True, "c6": True, "c7": True, "c8": True},
        # row 1: c8 is True, should always pass
        {"c1": 0.0, "c2": 0.0, "c3": 0.0, "c1_check": False, "c2_check": False, "c3_check": False, "c4": False, "c5": False, "c6": False, "c7": False, "c8": True},
        # row 2: c1 and c2 are 1.0, should always pass
        {"c1": 1.0, "c2": 1.0, "c3": 0.0, "c1_check": True, "c2_check": True, "c3_check": False, "c4": False, "c5": False, "c6": False, "c7": False, "c8": False},
        # row 3: Only two trues, should fail
        {"c1": 0.4, "c2": 0.4, "c3": 0.4, "c1_check": False, "c2_check": False, "c3_check": False, "c4": True, "c5": True, "c6": False, "c7": False, "c8": False}
    ])

    true_columns = ["c1_check", "c2_check", "c3_check", "c4", "c5", "c6", "c7", "c8"]
    minimum_trues = 3

    actual = select_criteria(df, minimum_trues, true_columns)
    expected = df.iloc[[0,1,2]]
    pd.testing.assert_frame_equal(actual, expected)


