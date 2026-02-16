FROM ghcr.io/josephmillsatwork/mantle-ai-cuda:12.8-cu128

ARG COMFYUI_VERSION=v0.13.0
ARG COMFYUI_MANAGER_VERSION=3.39.1

RUN groupadd comfyui -g 1000 && \
    useradd comfyui -u 1000 -g 1000 --create-home --home-dir /home/comfyui

RUN git clone -b ${COMFYUI_VERSION} https://github.com/comfyanonymous/ComfyUI.git /srv/ai/ComfyUI
RUN python -m pip install -r /srv/ai/ComfyUI/requirements.txt

RUN mkdir -p /srv/ai/bootstrap

RUN git clone -b ${COMFYUI_MANAGER_VERSION} https://github.com/Comfy-Org/ComfyUI-Manager.git /srv/ai/bootstrap/comfyui-manager && \
    python -m pip install -r /srv/ai/bootstrap/comfyui-manager/requirements.txt

RUN git clone https://github.com/city96/ComfyUI-GGUF.git \
        /srv/ai/bootstrap/ComfyUI-GGUF && \
    python -m pip install -r /srv/ai/bootstrap/ComfyUI-GGUF/requirements.txt

RUN git clone https://github.com/JosephMillsAtWork/JON.git /srv/ai/bootstrap/comfy-jnodes

COPY models.sh /srv/ai
COPY loras.sh  /srv/ai

RUN chown -R 1000:1000 /srv/ai

WORKDIR /srv/ai/ComfyUI
EXPOSE 8188

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

USER comfyui
