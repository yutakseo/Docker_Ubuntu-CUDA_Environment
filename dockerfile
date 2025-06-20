# Dockerfile
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3.10-venv \
    git \
    curl \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# pip 업그레이드 및 PyTorch 설치 (CUDA 11.8)
RUN python3.10 -m pip install --upgrade pip
RUN python3.10 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# 작업 디렉토리 설정
WORKDIR /workspace

CMD ["/bin/bash"]
