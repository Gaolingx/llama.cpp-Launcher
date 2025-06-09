#!/bin/bash

# ============= 用户配置区域 =============
SERVER_DIR="/home/ecs-user/soft/ik_llama.cpp/build/bin"
MODEL_PATH="/home/ecs-user/downloadLLM/models/Qwen/Qwen3-235B-A22B-GGUF/Q8_0/Qwen3-235B-A22B-Q8_0-00001-of-00009.gguf"
HOST="::"
PORT=21434
NUM_THREADS=16
GPU_LAYERS=0
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

echo "正在启动 llama-server..."
echo "启动时间：$(date +'%Y-%m-%d %H:%M:%S')"  # 标准化时间格式
echo "模型路径：$MODEL_PATH"
echo "监听地址：$HOST:$PORT"
echo "CPU线程数量：$NUM_THREADS"
echo "GPU加速层数：$GPU_LAYERS"
echo "上下文大小：$CTX_SIZE"

# 启动llama-server并捕获退出状态
./llama-server --model "$MODEL_PATH" \
    --host "$HOST" \
    --port "$PORT" \
    --threads "$NUM_THREADS" \
    --n-gpu-layers "$GPU_LAYERS" \
    --ctx-size "$CTX_SIZE" \
    --flash-attn \
    --run-time-repack \
    --fused-moe \
    --smart-expert-reduction 6,1

# 检查llama-server退出状态
if [ $? -ne 0 ]; then
    echo "[错误] llama-server 进程已退出"
    sleep 5  # Linux下使用sleep替代timeout
    exit 1
fi