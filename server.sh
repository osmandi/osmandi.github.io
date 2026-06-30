#!/usr/bin/bash

# Build the container
podman build -t quarto -f Containerfile .

# Run container
podman run \
	-d \
	-v ./website:/app/website \
	-p 8080:8080 \
	quarto \
	/usr/bin/bash -c "quarto preview website --port 8080 --host 0.0.0.0"
