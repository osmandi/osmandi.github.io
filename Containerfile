FROM docker.io/r-base:4.5.0

WORKDIR /quarto

# Expose ports
EXPOSE 7879

# Update Image base and install packages
RUN apt update \
  && apt-get -y upgrade \
  && apt-get install -y wget curl sqlite3

# Install UV - Astral
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.31/quarto-1.7.31-linux-amd64.deb \
  && dpkg -i ./quarto-1.7.31-linux-amd64.deb \
  && quarto install tinytex

# Install R packages
RUN R -e "install.packages(c('rmarkdown', 'knitr',  'ggplot2', 'DBI', 'RSQLite', 'dplyr'))" \
  && R -e "install.packages('dbplyr', dependencies = TRUE)"

# COPY files to Python UV
COPY ./pyproject.toml ./uv.lock ./.python-version /quarto/

CMD quarto preview website --port 7879 --host 0.0.0.0 --no-browser
