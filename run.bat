@echo off
set VOLUME_DIR=Ubuntu_22.04_CUDA_11.08

REM 디렉토리가 없다면 생성
IF NOT EXIST "%VOLUME_DIR%" (
    echo [INFO] Creating directory: %VOLUME_DIR%
    mkdir %VOLUME_DIR%
) ELSE (
    echo [INFO] Directory already exists: %VOLUME_DIR%
)

REM Docker Compose 실행
echo [INFO] Starting Docker Compose...
docker compose up --build -d

pause
