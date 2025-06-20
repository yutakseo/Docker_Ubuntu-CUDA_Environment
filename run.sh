#!/bin/bash

VOLUME_DIR="Ubuntu_22.04_CUDA_11.08"

# 디렉토리 없으면 생성
if [ ! -d "$VOLUME_DIR" ]; then
    echo "[INFO] Creating directory: $VOLUME_DIR"
    mkdir -p "$VOLUME_DIR"
else
    echo "[INFO] Directory already exists: $VOLUME_DIR"
fi

# Docker Compose 실행
echo "[INFO] Starting Docker Compose..."
docker compose up --build -d
