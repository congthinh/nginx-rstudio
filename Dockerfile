# Mobivi NginX Docker file
# Business Intelligence Department - Thinh Huynh
# May 2016
FROM nginx:1.9.15
MAINTAINER Thinh Huynh "thinh.hc@mobivi.vn"

#Add to sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ xenial main universe" >> /etc/apt/sources.list

RUN apt-get update && \ 
apt-get upgrade -y

RUN apt-get -y install wget tar ca-certificates

# Install nginx:
RUN which nginx || ( ps aux | grep nginx  | grep -v grep ) || apt-get install -y -q nginx

#RUN mkdir -p /etc/nginx/isplab_locations

#COPY rstudio-server.conf /etc/nginx/isplab_locations
#COPY isplab-main.conf /etc/nginx/sites-available

#RUN cd /etc/nginx/sites-enabled
#RUN ln -s /ect/nginx/sites-available/isplab-main.conf isplab-main.conf
#RUN ls /etc/nginx/sites-available
#RUN unlink "/etc/nginx/sites-available/default"

#RUN service nginx reload || (echo "Error reloading nginx"; exit 1)

## Use s6 
#RUN wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz \
#&& tar xzf /tmp/s6-overlay-amd64.tar.gz -C / 

#EXPOSE 80 443

#CMD ["/init"]

COPY nginx.conf /etc/nginx/nginx.conf
