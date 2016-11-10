# Docker image with nginx, ssl and http2 support

## Versions

    $ nginx -V
    nginx version: nginx/1.10.2
    built by gcc 4.9.2 (Debian 4.9.2-10)
    built with OpenSSL 1.0.2j  26 Sep 2016

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

You can use volumes to site config, certificates and public data:

    docker pull gustavopaes/nginx-ssl-h2
    
    docker run -p 127.0.0.1:80:80 -p 127.0.0.1:443:443 -i \
        -v /home/user/website/nginx/cert:/etc/ngx/ssl/ \
        -v /home/user/website/nginx/default.conf:/etc/nginx/sites-enabled/default \
        -v /home/user/website/public/:/var/www \
        gustavopaes/nginx-ssl-h2 \
        nginx

`/local/path/to/certs/` need to have all three files:
* fullchain.pem
* privkey.pem
* dhparam.pem

## why and how create `dhparam.pem` file?

The main goal is to get **"A"** rating on [Qualys SSL Labs](https://www.ssllabs.com/ssltest/analyze.html), and to do that is necessary to create your own `dhparam`. You can read more on [Forward Secrecy & Diffie Hellman Ephemeral Parameters](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html#Forward_Secrecy_&_Diffie_Hellman_Ephemeral_Parameters).

    openssl dhparam -out dhparam.pem 4096
    (will take long long time)


## basic nginx site configuration

You don't need configure any certification path or SSL configuration on your nginx site conf.

    server {
      listen 443 ssl http2;
      server_name www.yourdomain.com.br;

      index index.htm index.hml;
      root /var/www/;
      charset utf-8;

      expires $expires;

      gzip_disable "MSIE [1-6]\.(?!.*SV1)";

      ## all locations
      location / {
        error_page 404 /index.htm;
      }
    }


------

strongly inspired on [Ehekatl](https://github.com/Ehekatl/docker-nginx-http2) code
