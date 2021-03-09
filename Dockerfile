FROM ubuntu:20.04
SHELL ["/bin/bash", "--login", "-c"]

ENV TZ=Europe/Berlin

# To solve invoke-rc.d error for openssh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
&& printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d \
&& apt-get update \
&& apt-get install -y ssh \
    gcc-9 \
    g++-9 \
    cmake \
    git \
    wget \
    tmux \
    clang \
    rsync \
    tar \
    dirmngr\
    curl \
&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 \
&&  apt-get install --no-install-recommends -y \
    software-properties-common \
&& apt-get clean

RUN wget \
    https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin \
    && mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
    && wget https://developer.download.nvidia.com/compute/cuda/11.1.0/local_installers/cuda-repo-ubuntu2004-11-1-local_11.1.0-455.23.05-1_amd64.deb \
    && dpkg -i cuda-repo-ubuntu2004-11-1-local_11.1.0-455.23.05-1_amd64.deb \
    && apt-key add /var/cuda-repo-ubuntu2004-11-1-local/7fa2af80.pub \
    && apt-get update \
    && apt-get -y --no-install-recommends install cuda-toolkit-11-1 libnvidia-ml-dev \
    && apt-get clean

ENV PATH="/opt/miniconda-latest/bin:${PATH}"
ARG PATH="/opt/miniconda-latest/bin:${PATH}"

ENV CONDA_DIR="/opt/miniconda-latest" \
    PATH="/opt/miniconda-latest/bin:$PATH"


COPY ./environment.yml .

RUN chmod 777 /opt && chmod a+s /opt \
    && echo "Downloading Miniconda installer ..." \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && rm -f "$conda_installer" \
    && conda update -yq -nbase conda \
    && conda init bash \
    && conda env create -n pytorch --file environment.yml \
    && conda clean -a -y \
    && rm -rf ~/.cache/pip/* \
    && ln -s /opt/miniconda-latest/etc/profile.d/conda.sh /etc/profile.d/conda.sh

RUN useradd -m user \
  && yes password | passwd user \
  && chmod -R a+rw /home/user

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin no'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_clion \
  && ldconfig

ENTRYPOINT ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_clion"]
