FROM nvidia/cuda:12.9.0-cudnn-devel-ubuntu24.04

# System setup
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-venv wget ffmpeg libsm6 libxext6 && \
    rm -rf /var/lib/apt/lists/*

# Install ComfyUI
WORKDIR /workspace
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Install PyTorch (GPU) and dependencies FIRST
RUN pip3 install --upgrade pip && \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install the rest of the requirements
RUN pip3 install -r requirements.txt

# (Optional: Download/checkpoint models here if you want them baked in)
# RUN wget -O /workspace/models/yourmodel.safetensors http://link-to-model

# Expose web UI port
EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
