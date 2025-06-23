# CUDA 11.8 + cuDNN 포함된 기본 이미지 사용
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# 시스템 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl git nano sudo \
    libgl1-mesa-glx libglib2.0-0 libglib2.0-dev \
    libsm6 libxrender1 libxext6 ffmpeg unzip \
    && rm -rf /var/lib/apt/lists/*

# Miniconda 설치
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN curl -sLo ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh && \
    bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh && \
    conda clean -afy && \
    pip install --upgrade pip && \
    conda init bash

# bash를 기본 쉘로 설정
SHELL ["/bin/bash", "-c"]

# 작업 디렉토리 생성
WORKDIR /workspace

# 기본 패키지 설치 (원한다면 여기서 더 추가 가능!)
RUN pip install opencv-python-headless matplotlib tqdm seaborn
# requirements.txt 복사
COPY requirements.yaml /workspace/requirements.yaml

# 기본 bash 쉘 실행
CMD ["/bin/bash"]
