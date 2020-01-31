#!/usr/bin/env bash

export BASE=$HOME/Desktop/

export PODCAST_ASSETS_DIR=${BASE}/pipeline/assets
export PODCAST_OUTPUT_DIR=${BASE}/output/
export PODCAST_INPUT_DIR=${BASE}/input

mkdir -p $PODCAST_INPUT_DIR
mkdir -p $PODCAST_OUTPUT_DIR

pipenv run python podcast.py
