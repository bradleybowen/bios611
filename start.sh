#!/bin/bash

docker build -t 611projects .

docker run -it \
  -p 8787:8787 \
  -v "$(pwd):/home/rstudio/work" \
  -e USERID=$(id -u) \
  -e GROUPID=$(id -g) \
  -e PASSWORD=rstudio \
  611projects


