import pytest
import csv
from pathlib import Path

from project1developers import read_devs
from project1developers import process

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

   
