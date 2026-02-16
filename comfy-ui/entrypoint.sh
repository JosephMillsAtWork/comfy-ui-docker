#!/bin/bash
set -e

REQUIRED_UID=1000
REQUIRED_GID=1000

if [ "$(id -u)" != "$REQUIRED_UID" ];
then
    echo "CRITICAL ERROR: Container process must run as UID $REQUIRED_UID."
    exit 1
fi

BOOTSTRAP_DIR="/srv/ai/bootstrap"
NODES_DIR="/srv/ai/ComfyUI/custom_nodes"

echo "Checking for essential custom nodes..."
for NODE in "comfyui-manager" "ComfyUI-GGUF" "comfy-jnodes";
do
    if [ ! -d "$NODES_DIR/$NODE" ];
    then
        echo "Syncing $NODE to mounted volume..."
        cp -r "$BOOTSTRAP_DIR/$NODE" "$NODES_DIR/"
    else
        echo "Node $NODE already present in volume."
    fi
done

CHECK_PATHS=(
    "/srv/ai/ComfyUI/models"
    "/srv/ai/ComfyUI/output"
    "/srv/ai/ComfyUI/custom_nodes"
    "/srv/ai/ComfyUI/user"
)

for MOUNT in "${CHECK_PATHS[@]}";
do
    if [ ! -d "$MOUNT" ];
    then
        echo "Warning: $MOUNT not found, skipping check."
        continue
    fi

    OWNER_ID=$(stat -c '%u' "$MOUNT")
    GROUP_ID=$(stat -c '%g' "$MOUNT")

    if [ "$OWNER_ID" != "$REQUIRED_UID" ] || [ "$GROUP_ID" != "$REQUIRED_GID" ];
    then
        echo "PERMISSION ERROR: Mount point '$MOUNT' is owned by $OWNER_ID:$GROUP_ID."
        echo "It MUST be owned by $REQUIRED_UID:$REQUIRED_GID."
        echo "Run this on your host: sudo chown -R 1000:1000 /srv/ai/comfy"
        exit 1
    fi
done

exec /usr/bin/python3 main.py "$@"
