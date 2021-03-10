`environment.yml` created with:

```
conda create -n common-torch -c pytorch -c conda-forge python=3.7 pytorch=1.8.0=py3.7_cuda10.2_cudnn7.6.5_0 cudnn=7.6.5=cuda10.2_0 cudatoolkit=10.2.89 torchvision nvidia-apex numpy pandas matplotlib scipy uproot jupyterlab pickleshare dill 

conda activate common-torch
pip install nvgpu comet-ml
```
