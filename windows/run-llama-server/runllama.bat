@echo on
setlocal enabledelayedexpansion

REM ====== CMD编码设置 ======
chcp 65001 > nul

REM ============= 用户配置区域 =============
set "SERVER_DIR=D:\llama\llama-b4793-bin-win-cuda-cu12.4-x64"
set "MODEL_PATH=D:\Models\ollama\blobs\sha256-1bcc8fe7577751eb97f552e7ee2229f1c6a0076d31949d9cd052867b4b5e5bed"
set "HOST=::"
set "PORT=21434"
set "NUM_CTX=10"
set "GPU_LAYERS=8"
set "CTX_SIZE=4096"
REM ============= 配置结束 ==============

title Llama Server 控制台
color 0A

REM 检查必要目录和文件
if not exist "%SERVER_DIR%\llama-server.exe" (
    echo [错误] 未找到llama-server.exe
    exit /b 1
)

if not exist "%MODEL_PATH%" (
    echo [错误] 模型文件不存在
    exit /b 1
)

REM 切换工作目录
pushd "%SERVER_DIR%" || (
    echo 无法切换到目录：%SERVER_DIR%
    exit /b 1
)

echo 正在启动Llama服务器...
echo 启动时间：%date% %time%
echo 模型路径：%MODEL_PATH%
echo 监听地址：%HOST%:%PORT%
echo CPU线程数量：%NUM_CTX%
echo GPU加速层数：%GPU_LAYERS%
echo 上下文大小：%CTX_SIZE%

REM 启动服务器并记录日志
llama-server -m "%MODEL_PATH%" --host %HOST% --port %PORT% --threads %NUM_CTX% --n-gpu-layers %GPU_LAYERS% --ctx-size %CTX_SIZE%

if %errorlevel% neq 0 (
    echo [错误] 服务器启动失败
    timeout /t 5 /nobreak >nul
    popd
    exit /b 1
)

popd
endlocal