# CUDA 11.8 + Ubuntu 22.04
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# 기본 패키지
RUN apt-get update && apt-get install -y \
    curl git nano sudo && \
    rm -rf /var/lib/apt/lists/*

# Miniconda (Python 3.8 내장된 안정 구버전) 설치
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN curl -sLo ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh && \
    bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh && \
    conda clean -afy && \
    pip install --upgrade pip


# 작업 디렉토리 설정
WORKDIR /workspace

CMD ["/bin/bash"]
