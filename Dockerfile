FROM debian:bookworm-slim

# Instala Nginx y Mercurial
RUN apt-get update && apt-get install -y nginx mercurial fcgiwrap spawn-fcgi apache2-utils

# Prepara el directorio para los repositorios
RUN mkdir /mercurial_repos
WORKDIR /mercurial_repos

# Configura Nginx para servir hgweb
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-enabled/mercurial

#Preparamos script y configuracion de hgweb
RUN mkdir /etc/nginx/hg
COPY hgweb.cgi /etc/nginx/hg
RUN chmod +x /etc/nginx/hg/hgweb.cgi
COPY hgweb.config /etc/nginx/hg

COPY setchown.sh /etc/nginx/hg

# Expone el puerto 80 para Nginx
EXPOSE 80

# Copia el script de inicio en el contenedor
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Usa el script de inicio como el comando por defecto
CMD ["/start.sh"]

