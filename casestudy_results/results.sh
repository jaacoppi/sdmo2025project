#!/bin/bash
tests/run_tests.sh inputs/libreoffice_core.csv analyzed/t05/libreoffice_core_analyzed.csv 0.5 | tee libreoffice_t05_results.txt
tests/run_tests.sh inputs/godot.csv analyzed/t05/godot_analyzed.csv 0.5 | tee godot_t05_results.txt
tests/run_tests.sh inputs/nextjs.csv analyzed/t05/nextjs_t05_750_analyzed.csv 0.5 | tee nextjs_05_results.txt
tests/run_tests.sh inputs/algorithms_python.csv analyzed/t05/algorithms_python_analyzed.csv 0.5 | tee algorithms_t05_results.txt
tests/run_tests.sh inputs/tensorflow.csv analyzed/t05/tensorflow_analyzed.csv 0.5 | tee tensorflow_results.txt
tests/run_tests.sh inputs/opencv.csv analyzed/t05/opencv_analyzed_t05.csv 0.5 | tee opencv_t05_results.txt

