FROM rocker/rstudio
RUN yes | unminimize
RUN apt update && apt install -y man-db manpages && rm -rf /var/lib/apt/lists/*
