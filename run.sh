#!/bin/bash

# 기본 작업 디렉토리
VOLUME_DIR="$(pwd)"
DATASETS_FILE="datasets.list"
COMPOSE_FILE="docker-compose.yaml"

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

# 절대 경로로 변환
VOLUME_DIR="$(realpath "$VOLUME_DIR")"

# docker-compose.yaml 생성 시작
cat > $COMPOSE_FILE <<EOF
version: '3.9'

services:
  ubuntu-gpu:
    build:
      context: .
      dockerfile: Dockerfile
    image: ubuntu22.04_cuda11.08_image
    container_name: ubuntu22.04_cuda11.08_container
    tty: true
    stdin_open: true
    entrypoint: /bin/bash
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    volumes:
      - ${VOLUME_DIR}:/workspace
EOF

# datasets.list가 있다면 추가로 마운트
if [[ -f "$DATASETS_FILE" ]]; then
    while IFS= read -r dataset_path; do
        [[ -z "$dataset_path" ]] && continue
        dataset_path_clean="$(realpath "$dataset_path")"
        dataset_name="$(basename "$dataset_path_clean")"
        echo "      - ${dataset_path_clean}:/workspace/datasets/${dataset_name}" >> $COMPOSE_FILE
    done < "$DATASETS_FILE"
fi

# docker-compose 실행
echo "[INFO] Generated docker-compose.yaml with datasets:"
cat $COMPOSE_FILE
echo "[INFO] Launching container..."
docker compose -f $COMPOSE_FILE up --build -d
