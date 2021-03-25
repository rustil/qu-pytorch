#!/bin/bash --login
set -e

conda activate common-torch
exec "$@"
