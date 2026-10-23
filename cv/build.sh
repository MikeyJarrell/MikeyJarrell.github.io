#!/bin/bash
# Build the CV and put the PDF where the website links to it.
#
#   bash cv/build.sh
#
# Compiles cv/cv.tex with latexmk, keeping LaTeX's scratch files in cv/build/
# (ignored by git), then copies the finished PDF to static/pdf/cv.pdf, the
# file mikeyjarrell.com links to. Commit cv.tex and static/pdf/cv.pdf together.
set -euo pipefail
cd "$(dirname "$0")"                                  # run from the cv/ folder
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build cv.tex
cp build/cv.pdf ../static/pdf/cv.pdf                  # the copy the site serves
echo "Built static/pdf/cv.pdf"
