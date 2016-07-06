# Docker image with nginx, ssl and http2 support

## Dockerfile example

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

## Command line example

You can use volumes:

    docker run -v local/path/to/certs/:/etc/nginx/ssl/ -v local/nginx/site.conf:/etc/nginx/sites-enabled/default

`local/path/to/certs/` need to have all three files:
* fullchain.pem
* privkey.pem
* dhparam.pem

## why and how create `dhparam.pem` file?

The main objective is to get **"A"** rating on [Qualys SSL Labs](https://www.ssllabs.com/ssltest/analyze.html), and to do that is necessary to create your own `dhparam`. You can read more on [Forward Secrecy & Diffie Hellman Ephemeral Parameters](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html#Forward_Secrecy_&_Diffie_Hellman_Ephemeral_Parameters)

    openssl dhparam -out dhparam.pem 4096


------

strongly inspired on [Ehekatl](https://github.com/Ehekatl/docker-nginx-http2) code
