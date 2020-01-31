#!/usr/bin/env bash
cd $(dirname $0)/..
txt=requirements.txt
pipenv lock -r > ${txt}
pip download -d vendor -r ${txt}

