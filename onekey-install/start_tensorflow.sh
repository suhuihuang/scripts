#!/bin/bash

source /app/public/archiconda3/etc/profile.d/conda.sh
conda activate test
export PYTHONPATH=$PYTHONPATH:/app/public/tensorflow1.13.1-py36/lib/python3.6/site-packages/
