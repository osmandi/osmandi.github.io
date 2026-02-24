FROM python:3.12-slim AS base

RUN apt-get update && \
    apt-get install -y wget && \
    mkdir /quarto && \
    wget -O /quarto/quarto.deb https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.27/quarto-1.8.27-linux-amd64.deb

FROM python:3.12-slim AS main
WORKDIR /app
COPY --from=base /quarto /quarto
COPY requirements.txt .
RUN dpkg -i /quarto/quarto.deb && pip install -r requirements.txt
CMD ["quarto", "--help"]