FROM rocker/rstudio

RUN yes | unminimize

RUN apt update && \
    apt install -y man-db manpages manpages-dev && \
    rm -rf /var/lib/apt/lists/*

