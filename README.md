## ComfyUI Docker for RTX 50-Series (Blackwell)

This setup provides a Dockerized ComfyUI environment specifically patched for NVIDIA RTX 50-series GPUs (sm_120) using CUDA 12.8 and PyTorch Nightly.

---

### Prerequisites

* **NVIDIA Drivers**: Version 570+ installed on the host.
* **NVIDIA Container Toolkit**: Installed and configured for Docker.
* **Hardware**: RTX 5070 Ti or similar Blackwell architecture.

---

### Project Structure

```text
.
├── comfy-ui/
│   ├── Dockerfile       # Builds environment with CUDA 12.8 + Torch Nightly
│   ├── entrypoint.sh   # Container start script
│   ├── loras.sh        # Script for downloading LoRA models
│   └── models.sh       # Script for downloading Base/GGUF models
├── docker-compose.yml   # GPU reservations and volume mappings
└── start.sh             # Shortcut to build and launch

```

---

### Configuration

#### 1. Volume Mappings

The `docker-compose.yml` maps local directories to the container. Ensure these paths exist on your host or update them:

* `/srv/ai/comfy/models`
* `/srv/ai/comfy/custom_nodes`
* `/srv/ai/comfy/output`

#### 2. Network Access

The UI is bound to `127.0.0.1:8188`. It will only be accessible from the local machine. To allow remote access, change the port mapping in `docker-compose.yml` to `"8188:8188"`.

---

### Usage

#### Start the Container

Run the provided start script:

```bash
./start.sh

```

#### Download Models

The `.sh` scripts inside the `comfy-ui` directory are templates. Add your `wget` commands there to manage your model library.

* Use `models.sh` for Checkpoints, UNET, and VAE.
* Use `loras.sh` for LoRAs (requires CivitAI API token for certain models).

---

### Hardware Notes
* **VRAM**: The configuration uses `--lowvram` with a reserve of 8GB to ensure stability on 16GB cards while handling high-resolution Flux/GGUF models.
* **Compatibility**: This build specifically bypasses the "sm_120 not compatible" error found in stable PyTorch releases.
