# QU-Pytorch Docker Image

this repository is used to build the `rustil/qu-pytorch` and `ilcsoft/qu-pytorch` images on DockerHub, providing a common environment for researchers from different groups.

The image is based on the official `pytorch/pytorch` image, to whom most of the credit for this image should go.

The image should run using `docker` or `singularity`, where

`docker/singularity run ilcsoft/qu-pytorch:base python -c 'my python commands'`

Executes your favourite python commands within the environment given by the [environment.yml](environment.yml).

In the docker world, a user called `user` is created, while for singularity you're likely using your host-user.

In case the `conda` command is not available to you in an interactive session (`singularity shell ...` / `docker run -it ...`), try to call `source /etc/profile.d/conda.sh` and use BASH.

`conda` belongs to `root`, so in case you want to change something to the environment, see if `sudo` could be your friend.

## Build the image

In order to build the (base) image you can simply do:

`docker build -t <name>:<tag> -f Dockerfile.base .`

from within this repository. You could choose a different base image by changing the `PYTORCH` build argument: `--build-arg PYTORCH=wishyouwhat`.


### Addendum

`environment.yml` created from existing environment in the pytorch image plus:

```
conda install -c pytorch -c conda-forge numpy pandas matplotlib scipy uproot jupyterlab pickleshare dill scikit-learn h5py

conda activate common-torch
pip install nvgpu comet-ml
```

Additionally, nvidia's APEX is installed by something like (not in `environment.yml`):

```
conda activate common-torch
git clone https://github.com/NVIDIA/apex
cd apex
pip install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
```         
