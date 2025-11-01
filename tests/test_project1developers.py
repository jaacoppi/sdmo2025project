import pytest
import csv
from project1developers import read_devs

"Creates sample csv with names and emails for tests"
@pytest.fixture
def sample_csv(tmp_path):
    file_path = tmp_path / "devs.csv"
    with open(file_path, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["name", "email"])
        writer.writerow(["erkki peltonen", "erkki.peltonen@gmail.com"])
        writer.writerow(["jakub", "jakub@school.warsaw.pl"])
        writer.writerow(["santeri5473", "5473@gratud.com"])
        writer.writerow(["päivi pölkynen", "päivi.pölkkynen@users.noreply.github.com"])
    return file_path

"Ensure read_devs reads all rows and skips the header"
def test_read_devs_return(sample_csv):
    result = read_devs(sample_csv)
    exception = [
        ["erkki peltonen", "erkki.peltonen@gmail.com"],
        ["jakub", "jakub@school.warsaw.pl"],
        ["santeri5473", "5473@gratud.com"],
        ["päivi pölkynen", "päivi.pölkkynen@users.noreply.github.com"]
    ]
    assert result == exception

"Ensure function handles a CSV with only the header"
def test_read_devs_empty_file(tmp_path):
    empty_file = tmp_path / "empty.csv"
    with open(empty_file, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["name", "email"])
    assert read_devs(empty_file) == []
