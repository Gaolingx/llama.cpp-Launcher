#!/bin/bash

# ============= 用户配置区域 =============
SERVER_DIR="/mnt/d/llama/llama-b4793-bin-win-cuda-cu12.4-x64"
MODEL_PATH="/mnt/d/Models/ollama/blobs/sha256-1bcc8fe7577751eb97f552e7ee2229f1c6a0076d31949d9cd052867b4b5e5bed"
NUM_CTX=14
GPU_LAYERS=8
CTX_SIZE=4096
# ============= 配置结束 ==============

# 检查必要文件
if [ ! -f "$SERVER_DIR/llama-cli" ]; then  # 移除.exe扩展名
    echo "[错误] 未找到llama-cli"
    exit 1
fi

if [ ! -f "$MODEL_PATH" ]; then
    echo "[错误] 模型文件不存在"
    exit 1
fi

# 切换工作目录
if ! cd "$SERVER_DIR"; then  # 简化目录切换检查
    echo "无法切换到目录：$SERVER_DIR"
    exit 1
fi

echo "正在启动Llama cli..."
echo "启动时间：$(date +'%Y-%m-%d %H:%M:%S')"  # 标准化时间格式
echo "模型路径：$MODEL_PATH"
echo "CPU线程数量：$NUM_CTX"
echo "GPU加速层数：$GPU_LAYERS"
echo "上下文大小：$CTX_SIZE"

# 启动客户端程序
./llama-cli -m "$MODEL_PATH" \
    --threads "$NUM_CTX" \
    --n-gpu-layers "$GPU_LAYERS" \
    --ctx-size "$CTX_SIZE"

# 检查执行结果
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    echo "[错误] 程序执行失败 (退出码: $EXIT_CODE)"
    sleep 5  # Linux下替代timeout命令
    exit 1
fi