# comment this if really 3060
FROM nvidia/cuda:12.8.0-runtime-ubuntu24.04

# uncomment this if really 3060
# ARG PYTORCH_VERSION=2.10.0-cuda12.6-cudnn9-runtime
# FROM pytorch/pytorch:${PYTORCH_VERSION}

ENV PIP_BREAK_SYSTEM_PACKAGES=1
ARG COMFYUI_VERSION=v0.13.0
ARG COMFYUI_MANAGER_VERSION=3.39.1

RUN apt-get update && \
    apt-get install --assume-yes \
        git \
        sudo \
        libgl1 \
        libglx-mesa0 \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender-dev \
        python3 python3-pip \
        wget && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN mkdir -p /srv/ai
RUN git clone -b ${COMFYUI_VERSION} https://github.com/comfyanonymous/ComfyUI.git /srv/ai/ComfyUI

# Install NIGHTLY PyTorch for CUDA 12.8+ support
RUN python -m pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128
RUN python -m pip install sqlalchemy
RUN python -m pip install -r /srv/ai/ComfyUI/requirements.txt

# Install requirements (3060 works with standard versions)
# RUN python -m pip install --upgrade pip
# RUN python -m pip install sqlalchemy
# RUN python -m pip install -r /srv/ai/ComfyUI/requirements.txt


RUN mkdir -p /srv/ai/ComfyUI/custom_nodes
RUN cd /srv/ai/ComfyUI/custom_nodes/ && \
    git clone -b ${COMFYUI_MANAGER_VERSION} https://github.com/Comfy-Org/ComfyUI-Manager.git /srv/ai/ComfyUI/custom_nodes/comfyui-manager && \
    git clone https://github.com/city96/ComfyUI-GGUF.git /srv/ai/ComfyUI/custom_nodes/ComfyUI-GGUF  && \
    git clone https://github.com/JosephMillsAtWork/JON.git /srv/ai/ComfyUI/custom_nodes/comfy-jnodes


COPY models.sh /srv/ai
COPY loras.sh  /srv/ai

WORKDIR /srv/ai/ComfyUI
EXPOSE 8188
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
