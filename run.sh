#Docker env setting shell Usage:
#type your dataset path in ___DATASETS___.list file, if you want to use your own datasets.
#bash run.sh -v /path/to/your/volume




# 설정값
VOLUME_DIR="$(pwd)"
DATASETS_FILE="___DATASETS___.list"
DOCKER_IMAGE="ubuntu-cuda-env"
CONTAINER_NAME="ubuntu-cuda-env-container"
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

# 절대 경로로 변환
VOLUME_DIR="$(realpath "$VOLUME_DIR")"

# Docker 이미지 존재 여부 확인 후 빌드
if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
    echo "[INFO] Docker image not found. Building..."
    docker build -t "$DOCKER_IMAGE" -f "$DOCKERFILE_PATH" .
else
    echo "[INFO] Docker image found: $DOCKER_IMAGE"
fi

# 기존 컨테이너 제거
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[INFO] Removing existing container: $CONTAINER_NAME"
    docker rm -f "$CONTAINER_NAME"
fi

# 볼륨 마운트 플래그 구성
VOLUME_FLAGS="-v ${VOLUME_DIR}:/workspace"

if [[ -f "$DATASETS_FILE" ]]; then
    mapfile -t dataset_paths < "$DATASETS_FILE"
    for dataset_path in "${dataset_paths[@]}"; do
        [[ -z "$dataset_path" ]] && continue
        dataset_path_clean="$(realpath "$dataset_path")"
        dataset_name="$(basename "$dataset_path_clean")"
        VOLUME_FLAGS+=" -v ${dataset_path_clean}:/workspace/mounted_datasets/${dataset_name}/"
    done
fi

# 컨테이너 실행
echo "[INFO] Running container: $CONTAINER_NAME"
docker run -d --gpus all \
  $VOLUME_FLAGS \
  --shm-size=64g \
  --name "$CONTAINER_NAME" \
  -it "$DOCKER_IMAGE" \
  /bin/bash

# requirements.txt 심볼릭 링크 생성
echo "[INFO] Creating symbolic link for requirements.txt inside container..."
docker exec "$CONTAINER_NAME" ln -sf /opt/requirements.txt /workspace/requirements.txt

echo "[INFO] Container is up and ready: $CONTAINER_NAME"