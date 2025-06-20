FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# 기본 패키지 설치
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

# conda 기본 셋업
RUN conda init bash

# conda 환경 생성 (Python 3.10 + PyTorch CUDA 11.8)
RUN conda create -n vision python=3.10 -y && \
    conda run -n vision pip install --upgrade pip && \
    conda run -n vision pip install pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu118


# 작업 디렉토리
WORKDIR /workspace

# 기본 환경 자동 활성화
SHELL ["/bin/bash", "-c"]
RUN echo "conda activate vision" >> ~/.bashrc

CMD ["/bin/bash"]
