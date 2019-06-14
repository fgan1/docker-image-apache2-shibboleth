FROM ubuntu:14.04

# Instaling dependencies
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y libapache2-mod-php5
RUN apt-get install -y libapache2-mod-shib2

# Adding modules on apache2
RUN a2enmod shib2
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod headers
RUN a2enmod proxy_http

# Temporary files. Is required to change this files when be configurate
COPY ./files-conf/HOSTNAME.com.crt /etc/ssl/certs/HOSTNAME.com.crt
COPY ./files-conf/HOSTNAME.com.key /etc/ssl/private/HOSTNAME.com.key

COPY ./files-conf/default.conf /etc/apache2/sites-available/default.conf
COPY ./files-conf/shibboleth-sp2.conf /etc/apache2/sites-available/shibboleth-sp2.conf

RUN a2ensite default.conf
RUN a2ensite shibboleth-sp2.conf

COPY ./files-conf/shibboleth2.xml /etc/shibboleth/shibboleth2.xml 
COPY ./files-conf/attribute-map.xml /etc/shibboleth/attribute-map.xml
COPY ./files-conf/attribute-policy.xml /etc/shibboleth/attribute-policy.xml

RUN mkdir /var/www/secure
COPY ./files-conf/index-secure.html /var/www/secure/index.html

RUN apt-get install ntp ntpdate
RUN service ntp stop
#RUN ntpdate a.ntp.br
RUN service ntp start

#RUN timedatectl set-timezone America/Recife

# Step 13 in the RNP configuration file
RUN sed -i 's/DAEMON_USER=_shibd/DAEMON_USER=root/g' /etc/init.d/shibd

RUN service apache2 start
RUN service shibd restart
