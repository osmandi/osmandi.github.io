FROM ubuntu:latest

WORKDIR /app

RUN apt-get update \
    && apt-get install -y wget

RUN wget -O quarto_install.deb https://github.com/quarto-dev/quarto-cli/releases/download/v1.10.18/quarto-1.10.18-linux-amd64.deb \
    && dpkg -i quarto_install.deb

EXPOSE 8080

ENTRYPOINT ["quarto"]
