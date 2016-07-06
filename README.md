## Docker image with nginx, ssl and http2 support

`Dockerfile` example using my [image on docker hub](https://hub.docker.com/r/gustavopaes/nginx-ssl-h2/):

    FROM gustavopaes/nginx-ssl-h2
    
    # site config
    COPY default.conf /etc/nginx/sites-enabled/default
    
    # ssl
    COPY cert/fullchain.pem /etc/nginx/ssl/fullchain.pem
    COPY cert/privkey.pem /etc/nginx/ssl/privkey.pem
    COPY cert/dhparam.pem /etc/nginx/ssl/dhparam.pem
    
    VOLUME /var/www
    
    EXPOSE 80 443
    
    CMD ["nginx"]

------

inspired by [Ehekatl](https://github.com/Ehekatl/docker-nginx-http2) code
