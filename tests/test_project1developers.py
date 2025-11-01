import pytest
import csv
from pathlib import Path

from project1developers import read_devs

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
