# Run

```Bash
# Build the container
podman build -t quarto -f Dockerfile .

# Run container
podman run -ti -v ./docs:/app/docs -v ./website:/app/website -p 8080:8080 quarto bash

# Render
quarto preview website --port 8080 --host 0.0.0.0
```

TODO:
- Add image for each article
- Create a new article
- Create an article related with PySpark

Test
