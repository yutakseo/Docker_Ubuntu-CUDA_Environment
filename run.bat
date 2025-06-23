@echo off
setlocal

REM 기본값: 현재 디렉토리
set "VOLUME_DIR=%cd%"

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

REM 디렉토리 존재 확인
IF NOT EXIST "%VOLUME_DIR%" (
    echo [INFO] Creating directory: %VOLUME_DIR%
    mkdir "%VOLUME_DIR%"
) ELSE (
    echo [INFO] Directory already exists: %VOLUME_DIR%
)

REM 절대 경로 변환
FOR /F "usebackq tokens=*" %%i IN (`powershell -NoProfile -Command "(Resolve-Path '%VOLUME_DIR%').Path"`) DO SET ABS_VOLUME_DIR=%%i

REM Docker Compose 실행
echo [INFO] Starting Docker Compose with volume: %ABS_VOLUME_DIR%
set VOLUME_DIR=%ABS_VOLUME_DIR%
docker compose up --build -d

pause
