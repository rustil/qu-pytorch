`environment.yml` created with:

```
conda create -n common-torch -c pytorch -c conda-forge python=3.7 pytorch=1.8.0=py3.7_cuda10.2_cudnn7.6.5_0 cudnn=7.6.5=cuda10.2_0 cudatoolkit=10.2.89 torchvision numpy pandas matplotlib scipy uproot jupyterlab pickleshare dill scikit-learn h5py

conda activate common-torch
pip install nvgpu comet-ml
```

and for apex (not in environment.yml) do:

```
conda activate common-torch
git clone https://github.com/NVIDIA/apex
cd apex
pip install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
```
