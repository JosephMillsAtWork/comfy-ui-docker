# Mantle ComfyUI Docker for RTX 50-Series (Blackwell)

Dockerized ComfyUI environment specifically patched for NVIDIA RTX 50-series GPUs (sm_120) using CUDA 12.8 and PyTorch Nightly.

### Hardware for this branch
* **NVIDIA Drivers**: Version 570+ installed on the host. 
* **NVIDIA Container Toolkit**: Installed and configured for Docker.
* **Hardware**: RTX 5070 Ti or similar Blackwell architecture.
* **VRAM**: The configuration uses `--lowvram` with a reserve of 8GB to ensure stability on 16GB cards while handling high-resolution models.
* **Compatibility**: This build specifically bypasses the "sm_120 not compatible" error found in stable PyTorch releases.

### Dependencies

**NOTE This is only tested on debian**

Installing NVIDIA stuff(you only have to do this once if not already done). 
```shell
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb && \
dpkg -i cuda-keyring_1.1-1_all.deb && \
echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg trusted=yes] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /" > /etc/apt/sources.list.d/cuda-debian12-x86_64.list && \
apt-get update && \
apt-get install --no-install-recommends -y \
    cuda-nvcc-12-8 \
    cuda-cudart-dev-12-8 \
    cuda-libraries-dev-12-8 \
    libcublas-dev-12-8 && \
rm cuda-keyring_1.1-1_all.deb
```

Add the NVIDIA Container Toolkit repository
```shell 
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

The `docker-compose.yml` maps local directories to the container. Ensure these paths exist on your host and are owned by user 1000 
You only have to do this one time.

```shell
mkdir -p /srv/ai/comfy/models
mkdir -p /srv/ai/comfy/custom_nodes
mkdir -p /srv/ai/comfy/output
chown -R 1000:1000 /srv/ai
```

### Start the Container

```shell
docker-compose up -d
```

The UI is bound to `127.0.0.1:8188`. It will only be accessible from the local machine. To allow remote access, change the port mapping in `docker-compose.yml` to `"8188:8188"`.

### Stop the Container

```shell
docker-compose down
```

### View logs for the Container
```shell
docker-compose logs -f comfyui
```

### GitHub Container Registry (GHCR)

If you just want the environment, you can pull the image directly

```shell
docker pull ghcr.io/josephmillsatwork/comfy-ui-docker:12.8-cu128
```
