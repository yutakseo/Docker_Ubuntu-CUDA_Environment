@echo off
setlocal ENABLEDELAYEDEXPANSION

REM 기본값: 현재 디렉토리
set "VOLUME_DIR=%cd%"
set "DATASETS_FILE=datasets.list"
set "COMPOSE_FILE=docker-compose.yaml"

REM 인자 파싱
:parse_args
if "%~1"=="" goto after_args
if "%~1"=="-v" (
    shift
    set "VOLUME_DIR=%~1"
)
shift
goto parse_args

:after_args

REM 절대 경로 변환 (PowerShell 사용)
FOR /F "usebackq tokens=*" %%i IN (`powershell -NoProfile -Command "(Resolve-Path '%VOLUME_DIR%').Path"`) DO SET "ABS_VOLUME_DIR=%%i"
set "VOLUME_DIR=%ABS_VOLUME_DIR%"

REM docker-compose.yaml 생성 시작
(
    echo version^: '3.9'
    echo.
    echo services^:
    echo.  ubuntu-gpu^:
    echo.    build^:
    echo.      context^: .
    echo.      dockerfile^: Dockerfile
    echo.    image^: ubuntu22.04_cuda11.08_image
    echo.    container_name^: ubuntu22.04_cuda11.08_container
    echo.    tty^: true
    echo.    stdin_open^: true
    echo.    entrypoint^: /bin/bash
    echo.    deploy^:
    echo.      resources^:
    echo.        reservations^:
    echo.          devices^:
    echo.            - driver^: nvidia
    echo.              count^: all
    echo.              capabilities^: [gpu]
    echo.    volumes^:
    echo.      - %VOLUME_DIR%:/workspace
) > "%COMPOSE_FILE%"

REM datasets.list에 따라 추가 마운트
IF EXIST "%DATASETS_FILE%" (
    FOR /F "usebackq delims=" %%A IN ("%DATASETS_FILE%") DO (
        SET "dataset_path=%%A"
        IF NOT "!dataset_path!"=="" (
            FOR /F "usebackq tokens=*" %%i IN (`powershell -NoProfile -Command "(Resolve-Path '!dataset_path!').Path"`) DO SET "abs_path=%%i"
            FOR %%d IN ("!abs_path!") DO SET "dataset_name=%%~nxd"
            echo      - !abs_path!:/workspace/datasets/!dataset_name! >> "%COMPOSE_FILE%"
        )
    )
)

REM Compose 실행
echo [INFO] Generated docker-compose.yaml:
type "%COMPOSE_FILE%"
echo.
echo [INFO] Launching container
