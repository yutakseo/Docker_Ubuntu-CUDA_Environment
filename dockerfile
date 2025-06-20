# CUDA 11.8 + Ubuntu 22.04
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Miniconda 설치
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN curl -sLo ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh && \
    conda clean -afy

# Python 3.8 설치 & pip 업그레이드
RUN conda install -y python=3.8 && \
    conda update -n base -c defaults pip && \
    pip install torch==2.4.0 torchvision==0.17.0 torchaudio==2.4.0 --index-url https://download.pytorch.org/whl/cu118

# 작업 디렉토리 설정
WORKDIR /workspace

# 기본 쉘
CMD ["/bin/bash"]
