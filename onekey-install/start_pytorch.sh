#!/bin/bash

.  /app/public/archiconda3/etc/profile.d/conda.sh
# source /app/public/archiconda3/etc/profile.d/conda.sh
conda activate test
export PYTHONPATH=$PYTHONPATH:/app/public/pytorch1.7.0-py36/lib/python3.6/site-packages
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/app/public/openblas-FT2000+/lib
