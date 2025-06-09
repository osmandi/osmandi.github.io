# Run

```Bash
# Compile image
podman build -t Containerfile -f quarto .

# Run container
podman run -ti -p 7879:7879 -v ./:/quarto quarto bash

# Run quarto preview in Python environment
uv run -- quarto preview website --port 7879 --host 0.0.0.0 --no-browser

# Run quarto preview in R environment
uv run -- quarto preview document.qmd --port 7879 --host 0.0.0.0

# Render
uv run -- quarto render website
```

