FROM --platform=linux/amd64 rocker/verse
RUN yes | unminimize
RUN apt update && apt install -y man-db manpages && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('ggplot2')"
RUN R -e "install.packages('tidyverse')"


RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org')"
RUN R -e "remotes::install_github('bdilday/GeomMLBStadiums')"