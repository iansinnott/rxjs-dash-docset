FROM node:6.11
MAINTAINER Ian Sinnott "ian989@gmail.com"
RUN apt-get update -y
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:dhor/myway
RUN apt-get install -y imagemagick graphicsmagick ghostscript
