#!/bin/bash

# Crea el directorio para el socket si no existe
mkdir -p /var/run
mkdir -p /mercurial_repos/repos

# Copiamos el cgi al repo
cp -a /etc/nginx/hg/hgweb.cgi /mercurial_repos/

# Copia hgweb.config al repo solo si no existe
if [ ! -f /mercurial_repos/hgweb.config ]; then
    cp -a /etc/nginx/hg/hgweb.config /mercurial_repos/
fi

if [ ! -f /mercurial_repos/.htpasswd ]; then
    htpasswd -bc /mercurial_repos/.htpasswd test test
fi

cp -a /etc/nginx/hg/setchown.sh /mercurial_repos

chown www-data:www-data /var/run /mercurial_repos /mercurial_repos/repos /mercurial_repos/hgweb.config /mercurial_repos/.htpasswd

# Inicia fcgiwrap a través de spawn-fcgi para escuchar en un socket de UNIX
spawn-fcgi -s /var/run/fcgiwrap.socket -u www-data -g www-data -- /usr/sbin/fcgiwrap

# Inicia Nginx en primer plano
nginx -g 'daemon off;'

