#!/bin/bash

MODELS_DIR="/srv/ai/ComfyUI/models"
UNET_DIR="${MODELS_DIR}/unet"
DM_DIR="${MODELS_DIR}/diffusion_models"
CK_DIR="${MODELS_DIR}/checkpoints"
LUM_DIR="${MODELS_DIR}/latent_upscale_models"
TE_DIR="${MODELS_DIR}/text_encoders"
VAE_DIR="${MODELS_DIR}/vae"

# example
# wget https://huggingface.co/unsloth/LTX-2-GGUF/resolve/main/ltx-2-19b-dev-Q4_K_M.gguf?download=true -P ${UNET_DIR}

