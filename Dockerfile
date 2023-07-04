FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

# set bash as current shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# install anaconda
RUN apt-get update
RUN apt-get install -y wget libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 && \
    apt-get clean
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

# set path to conda
ENV PATH /opt/conda/bin:$PATH

# setup conda virtual environment
COPY ./requirements.txt /tmp/requirements.txt
RUN conda update -n base -c defaults conda
RUN conda env create --name smalify -f /tmp/requirements.txt

RUN echo "conda activate smalify" >> ~/.bashrc
ENV PATH /opt/conda/envs/smalify/bin:$PATH
ENV CONDA_DEFAULT_ENV $smalify
RUN conda activate smalify

# PyTorch
RUN conda install -y pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
RUN conda install -c fvcore -c iopath -c conda-forge fvcore iopath
RUN conda install -c bottler nvidiacub
RUN conda install pytorch3d -c pytorch3d

# clearn
RUN rm -rf /var/lib/apt/lists/*
