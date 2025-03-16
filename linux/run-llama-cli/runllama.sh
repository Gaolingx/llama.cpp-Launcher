#!/bin/bash

# ============= 用户配置区域 =============
SERVER_DIR="/home/ecs-user/soft/llama.cpp/build/bin"
MODEL_PATH="/home/ecs-user/downloadLLM/models/unsloth/DeepSeek-R1-Distill-Qwen-32B-Q8_0.gguf"
NUM_CTX=14
GPU_LAYERS=5
CTX_SIZE=4096
# ============= 配置结束 ==============

# 检查必要目录和文件
if [ ! -f "$SERVER_DIR/llama-cli" ]; then  # 注意移除了.exe扩展名
    echo "[错误] 未找到llama-cli"
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

echo "正在启动 llama-cli..."
echo "启动时间：$(date +'%Y-%m-%d %H:%M:%S')"  # 标准化时间格式
echo "模型路径：$MODEL_PATH"
echo "CPU线程数量：$NUM_CTX"
echo "GPU加速层数：$GPU_LAYERS"
echo "上下文大小：$CTX_SIZE"

# 启动llama-cli并捕获退出状态
./llama-cli --model "$MODEL_PATH" \
    --threads "$NUM_CTX" \
    --n-gpu-layers "$GPU_LAYERS" \
    --ctx-size "$CTX_SIZE"

# 检查llama-cli退出状态
if [ $? -ne 0 ]; then
    echo "[错误] llama-cli 进程已退出"
    sleep 5  # Linux下使用sleep替代timeout
    exit 1
fi