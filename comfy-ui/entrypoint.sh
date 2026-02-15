#!/bin/bash

echo "Creating directories for models..."
MODEL_DIRECTORIES=(
    "checkpoints" "clip" "clip_vision" "configs" "controlnet" "diffusers"
    "diffusion_models" "embeddings" "gligen" "hypernetworks" "loras"
    "photomaker" "style_models" "text_encoders" "unet" "upscale_models"
    "vae" "vae_approx"
)
for MODEL_DIRECTORY in "${MODEL_DIRECTORIES[@]}"; do
    mkdir -p /srv/ai/ComfyUI/models/$MODEL_DIRECTORY
done

echo "Installing requirements for custom nodes..."
for CUSTOM_NODE_DIRECTORY in /srv/ai/ComfyUI/custom_nodes/*;
do
    if [ "$CUSTOM_NODE_DIRECTORY" != "/srv/ai/ComfyUI/custom_nodes/comfyui-manager" ] && [ -d "$CUSTOM_NODE_DIRECTORY" ];
    then
        if [ -f "$CUSTOM_NODE_DIRECTORY/requirements.txt" ];
        then
            CUSTOM_NODE_NAME=${CUSTOM_NODE_DIRECTORY##*/}
            echo "Checking requirements for ${CUSTOM_NODE_NAME//[-_]/ }..."
            # Use --no-cache-dir to keep the image/container size down
            pip install --quiet --no-cache-dir --requirement "$CUSTOM_NODE_DIRECTORY/requirements.txt"
        fi
    fi
done

# root ?
if [ -z "$USER_ID" ] || [ -z "$GROUP_ID" ];
then
    echo "Running container as root..."
    exec /usr/bin/python3 main.py \
        --port 8188 \
        --listen 0.0.0.0 \
        --disable-auto-launch \
        "$@"
else
    echo "Setting up comfyui-user ($USER_ID:$GROUP_ID)..."
    getent group "$GROUP_ID" > /dev/null 2>&1 || groupadd --gid "$GROUP_ID" comfyui-user
    id -u "$USER_ID" > /dev/null 2>&1 || useradd --uid "$USER_ID" --gid "$GROUP_ID" --create-home comfyui-user

    # Ensure the user owns the workspace
    chown -R "$USER_ID":"$GROUP_ID" /srv/ai/ComfyUI

    export PATH=$PATH:/home/comfyui-user/.local/bin

    echo "Running container as comfyui-user..."
    # IMPORTANT: Added --preserve-env to keep CUDA/GPU settings
    exec sudo --set-home --preserve-env --user \#$USER_ID \
        /usr/bin/python3 main.py \
            --port 8188 \
            --listen 0.0.0.0 \
            --disable-auto-launch \
            "$@"
fi
