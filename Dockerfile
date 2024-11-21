FROM debian:latest

# Instalaciones
RUN apt update
RUN apt -y install apache2
RUN apt -y install nodejs
RUN apt -y install npm
RUN npm install -g @angular/cli@18.2.10    

RUN mkdir -p /var/www/examen.dis.com/html /dev_vol

COPY /ExamenDocker /dev_vol
RUN ls /dev_vol -l && \
    chown -R www-data:www-data /var/www/examen.dis.com

# Construcción de la aplicación Angular
WORKDIR /dev_vol
RUN npm install && ng build

RUN ls /var/www/examen.dis.com/html -l


EXPOSE 80

VOLUME /dev_vol

CMD ["apache2ctl", "-D", "FOREGROUND"]