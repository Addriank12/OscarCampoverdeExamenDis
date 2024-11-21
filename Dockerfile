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

# Copiar los archivos construidos al directorio de Apache
RUN cp -r /dev_vol/dist/browser/* /var/www/examen.dis.com/html/

# Configurar Apache para servir el contenido
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/examen.dis.com/html\n\
    <Directory /var/www/examen.dis.com/html>\n\
        Options Indexes FollowSymLinks\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

RUN ls /var/www/examen.dis.com/html -l


EXPOSE 80

VOLUME /dev_vol

CMD ["apache2ctl", "-D", "FOREGROUND"]