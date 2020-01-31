#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

script_dir=$(dirname $0 )
processor_dir=${script_dir}/..
echo "${processor_dir} is the processor_dir"
source ${script_dir}/processor-environment.sh
cd ${processor_dir}
python3 -m pipenv run python main.py