#!/bin/bash

source /app/public/archiconda3/etc/profile.d/conda.sh
conda activate test
export PYTHONPATH=$PYTHONPATH:/app/public/pytorch1.7.0-py36/lib/python3.6/site-packages
