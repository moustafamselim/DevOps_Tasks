#!/bin/bash

echo "⏳⏳⏳ Build Image"  
#buid image
docker build -t newman:v1 .

echo "💣💣💣 Run"

#run image
docker run --rm  --dns=8.8.8.8 --dns=1.1.1.1 newman:v1 --version


