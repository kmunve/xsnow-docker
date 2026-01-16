# My base image based on Ubuntu. 
# Some basic software installed for convenience.

# Build using: docker build -t ubuntu-base-image .

# Run using: docker run -it ubuntu-base-image /bin/bash
# or when using zsh:
# Run using: docker run -it ubuntu-base-image /bin/zsh

FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg apt-transport-https \
    python3 vim git curl \ 
    && rm -rf /var/lib/apt/lists/*

# Installing ZSH adds ~400 MB to the image size.
RUN sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)"

# Install uv
ENV UV_INSTALL_DIR=/usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Copy requirements file
# COPY requirements.txt .

# Create virtual environment and install deps with uv
RUN uv venv /opt/venv \
 && . /opt/venv/bin/activate

# Use venv by default
ENV PATH="/opt/venv/bin:${PATH}"

# Installing xsnow
RUN git clone https://gitlab.com/avacollabra/postprocessing/xsnow \
 && cd xsnow \
 && uv pip install xsnow -e .	
 # or && uv pip install -e .[gpu,testing,dev]

RUN python -c "import xsnow; print(xsnow.__version__)"
