#!/bin/bash

# ============= 用户配置区域 =============
SERVER_DIR="/mnt/d/llama/llama-b4793-bin-win-cuda-cu12.4-x64"
MODEL_PATH="/mnt/d/Models/ollama/blobs/sha256-1bcc8fe7577751eb97f552e7ee2229f1c6a0076d31949d9cd052867b4b5e5bed"
HOST="::"
PORT=21434
NUM_CTX=14
GPU_LAYERS=8
CTX_SIZE=4096
# ============= 配置结束 ==============

# 检查必要目录和文件
if [ ! -f "$SERVER_DIR/llama-server" ]; then  # 注意移除了.exe扩展名
    echo "[错误] 未找到llama-server"
    exit 1
fi

if [ ! -f "$MODEL_PATH" ]; then
    echo "[错误] 模型文件不存在"
    exit 1
fi

# 切换工作目录
if ! cd "$SERVER_DIR"; then
    echo "无法切换到目录：$SERVER_DIR"
    exit 1
fi

echo "正在启动Llama服务器..."
echo "启动时间：$(date)"
echo "模型路径：$MODEL_PATH"
echo "监听地址：$HOST:$PORT"
echo "CPU线程数量：$NUM_CTX"
echo "GPU加速层数：$GPU_LAYERS"
echo "上下文大小：$CTX_SIZE"

# 启动服务器并捕获退出状态
./llama-server -m "$MODEL_PATH" \
    --host "$HOST" \
    --port "$PORT" \
    --threads "$NUM_CTX" \
    --n-gpu-layers "$GPU_LAYERS" \
    --ctx-size "$CTX_SIZE"

# 检查服务器退出状态
if [ $? -ne 0 ]; then
    echo "[错误] 服务器启动失败"
    sleep 5  # Linux下使用sleep替代timeout
    exit 1
fi