FROM --platform=linux/amd64 rocker/verse
RUN yes | unminimize
RUN apt update && apt install -y man-db manpages && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('ggplot2')"
RUN R -e "install.packages('tidyverse')"

