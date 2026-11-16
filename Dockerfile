FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV MINESTUDIO_GPU_RENDER=1
ENV UV_LINK_MODE=copy

# Install system dependencies required by MineStudio
RUN apt-get update && apt-get install -y \
    build-essential \
    openjdk-8-jdk \
    xvfb \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /workspace

# Copy uv files and Python version pin
COPY pyproject.toml uv.lock .python-version ./

# Install dependencies without building the local project yet
RUN uv sync --frozen --no-install-project

# Copy the rest of your project files (including src/minebot)
COPY . .

# Install the local project itself
RUN uv sync --frozen
