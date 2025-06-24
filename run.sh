#!/bin/bash

# 설정값
VOLUME_DIR="$(pwd)"
DATASETS_FILE="___DATASETS___.list"
DOCKER_IMAGE="ubuntu22.04_cuda11.08_image"
CONTAINER_NAME="ubuntu22.04_cuda11.08_container"
DOCKERFILE_PATH="Dockerfile"

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

VOLUME_DIR="$(realpath "$VOLUME_DIR")"

# Docker 이미지 빌드 (없으면 자동으로)
if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
    echo "[INFO] Docker image not found. Building..."
    docker build -t "$DOCKER_IMAGE" -f "$DOCKERFILE_PATH" .
else
    echo "[INFO] Docker image found: $DOCKER_IMAGE"
fi

# 컨테이너 실행 중이면 중지 후 삭제
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[INFO] Removing existing container: $CONTAINER_NAME"
    docker rm -f "$CONTAINER_NAME"
fi

# 볼륨 플래그 구성
VOLUME_FLAGS="-v ${VOLUME_DIR}:/workspace"

if [[ -f "$DATASETS_FILE" ]]; then
    mapfile -t dataset_paths < "$DATASETS_FILE"
    for dataset_path in "${dataset_paths[@]}"; do
        [[ -z "$dataset_path" ]] && continue
        dataset_path_clean="$(realpath "$dataset_path")"
        dataset_name="$(basename "$dataset_path_clean")"
        VOLUME_FLAGS+=" -v ${dataset_path_clean}:/workspace/datasets/${dataset_name}"
    done
fi

# 컨테이너 실행
echo "[INFO] Running container: $CONTAINER_NAME"
docker run -d --gpus all \
  $VOLUME_FLAGS \
  --name "$CONTAINER_NAME" \
  -it "$DOCKER_IMAGE" \
  /bin/bash
