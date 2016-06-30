# Docker image running nginx with ssl and http2 support

`Dockerfile` example using my [image on docker hub](docker pull gustavopaes/nginx-ssl-h2):

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
