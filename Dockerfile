# Mobivi R Docker file
# Business Intelligence Department - Thinh Huynh
# May 2016
## Start with the official rocker image providing 'base R' 
FROM debian:jessie 
MAINTAINER Thinh Huynh "thinh.hc@mobivi.vn"

# Install nginx:
RUN which nginx || ( ps aux | grep nginx  | grep -v grep ) || apt-get install -y -q nginx

RUN nginxlocationsdir="/etc/nginx/isplab_locations"
RUN mkdir -p "$nginxlocationsdir"

RUN cat << EOF | sudo tee "${nginxlocationsdir}/rstudio-server.conf"
    location /rstudio/ {
      rewrite ^/rstudio/(.*)$ /\$1 break;
      proxy_pass http://localhost:8787;
      proxy_redirect http://localhost:8787/ \$scheme://\$host/rstudio/;
      access_log /var/log/nginx/rstudio-access.log;
      error_log  /var/log/nginx/rstudio-error.log;
    }
EOF

RUN isplab_nginx_main="/etc/nginx/sites-available/isplab-main.conf"
RUN if [ ! -f "${isplab_nginx_main}" ]; then
cat << EOF | sudo tee "${isplab_nginx_main}"
  server {
   listen 80 default_server;
   index index.html;
   root /var/www;

   include /etc/nginx/isplab_locations/*.conf;
}
EOF
fi

(cd "/etc/nginx/sites-enabled"; sudo ln -s "../sites-available/isplab-main.conf" "isplab-main.conf")

sudo service nginx reload || (echo "Error reloading nginx"; exit 1)

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
