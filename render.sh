#!/usr/bin/bash

# Build the container
podman build -t quarto -f Containerfile .

# Run container
podman run -d \
	-v ./docs:/app/docs \
	-v ./website:/app/website \
	quarto \
	quarto render website
