# Mobivi NginX Docker file
# Business Intelligence Department - Thinh Huynh
# May 2016
## Start with the official rocker image providing 'base R' 
FROM nginx:1.9.6
MAINTAINER Thinh Huynh "thinh.hc@mobivi.vn"

# Install nginx:
RUN which nginx || ( ps aux | grep nginx  | grep -v grep ) || apt-get install -y -q nginx

RUN nginxlocationsdir="/etc/nginx/isplab_locations"
RUN mkdir -p "$nginxlocationsdir"

ADD rstudio-server.conf /etc/nginx/isplab_locations
ADD isplab-main.conf /etc/nginx/sites-available

RUN (cd "/etc/nginx/sites-enabled"; ln -s "../sites-available/isplab-main.conf" "isplab-main.conf"; unlink -s "/etc/nginx/sites-enabled/default")

RUN service nginx reload || (echo "Error reloading nginx"; exit 1)

## Use s6 
RUN wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz \
&& tar xzf /tmp/s6-overlay-amd64.tar.gz -C / 

EXPOSE 80 443

CMD ["/init"]

