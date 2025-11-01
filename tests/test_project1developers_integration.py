import sys
import subprocess
from pathlib import Path
import pytest
import pandas as pd

def test_program_creates_correct_output(tmp_path):
    """ Integration test to see that the program produces correct outputs """
    TESTS_DIR = Path(__file__).parent
    input_file = TESTS_DIR / "integration_input.csv"
    expected_output_file = TESTS_DIR  / "integration_expected_output.csv"
    actual_output_file = tmp_path / "integration_test_output.csv"

    cmd = [
        sys.executable, "project1developers.py",
        "-i", str(input_file),
        "-o", str(actual_output_file),
        "-t", "0.5",
        "-m", "2"
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    assert result.returncode == 0, f"Program failed:\n{result.stderr}"
    assert actual_output_file.exists(), "Expected output file was not created"

    df_actual = pd.read_csv(actual_output_file)
    df_expected = pd.read_csv(expected_output_file)
    pd.testing.assert_frame_equal(df_actual, df_expected)

