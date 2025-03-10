FROM nvidia/opengl:base-ubuntu18.04

# 必要なパッケージのインストール
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 wget  git

# CUDA 10.1のインストール
RUN wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-ubuntu1804-10-1-local-10.1.105-418.39_1.0-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu1804-10-1-local-10.1.105-418.39_1.0-1_amd64.deb
RUN apt-get install -y gnupg
RUN apt-key add /var/cuda-repo-10-1-local-10.1.105-418.39/7fa2af80.pub
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y cuda
# 環境変数の設定
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# Anacondaのインストール
RUN wget -P /opt https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh && \
    bash /opt/Anaconda3-2020.02-Linux-x86_64.sh -b -p /opt/anaconda3 && \
    rm /opt/Anaconda3-2020.02-Linux-x86_64.sh
RUN echo "export PATH=/opt/anaconda3/bin:$PATH" >> ~/.bashrc && \
    . ~/.bashrc
RUN /opt/anaconda3/bin/conda init


WORKDIR /root
COPY . /root/SMALify
RUN /opt/anaconda3/bin/conda env create -f /root/SMALify/environment.yml

# Download  BADJA videos
# wgetで以下のビデオがダウンロードできなかったので、手動でダウンロードして解凍し、extra_videosを/root/SMALify/data/BADJA に置く
# https://drive.google.com/file/d/1ad1BLmzyOp_g3BfpE2yklNI-E1b8y4gy/view
# デフォルトの環境をsmalifyにする
RUN echo "conda activate smalify" >> ~/.bashrc

