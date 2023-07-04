FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime


RUN apt-get update && apt-get upgrade -y
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools

# OpenCV
RUN apt-get install -y libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libxext6
RUN pip install opencv-python
RUN pip install opencv-contrib-python

# torch
RUN pip install torchvision

# PyTorch 3D
WORKDIR /tmp
RUN apt-get install -y git
RUN git clone https://github.com/facebookresearch/pytorch3d.git
RUN apt-get install -y build-essential
RUN cd pytorch3d && pip install -e .

# pip
RUN apt-get install -y libgcc
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# clearn
RUN rm -rf /var/lib/apt/lists/*
