#!/bin/bash

# 기본 볼륨 디렉토리 = 현재 디렉토리
VOLUME_DIR="$(pwd)"

# 인자 파싱
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--volume)
            VOLUME_DIR="$2"
            shift
            ;;
        *)
            echo "[ERROR] Unknown parameter: $1"
            exit 1
            ;;
    esac
    shift
done

# 디렉토리 존재 확인 및 생성
if [ ! -d "$VOLUME_DIR" ]; then
    echo "[INFO] Creating directory: $VOLUME_DIR"
    mkdir -p "$VOLUME_DIR"
else
    echo "[INFO] Directory exists: $VOLUME_DIR"
fi

# 절대경로 변환
VOLUME_ABS=$(realpath "$VOLUME_DIR")

# 환경변수 설정
export VOLUME_DIR="$VOLUME_ABS"

# Docker Compose 실행
echo "[INFO] Starting Docker Compose with volume: $VOLUME_DIR"
docker compose up --build -d
