# It is following RNP tutorial
## https://wiki.rnp.br/pages/viewpage.action?pageId=69969868

# In the RNP tutorial the Ubuntu 14:04 is required because da dependency 'libapache2-mod-php5'
FROM ubuntu:14.04

# Instaling dependencies
# Step 1 in the RNP tutorial
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y libapache2-mod-php5
RUN apt-get install -y libapache2-mod-shib2
RUN apt-get install -y openssh-server

# Adding modules on apache2
RUN a2enmod shib2
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod headers
RUN a2enmod proxy_http

# Step 12 in the RNP tutorial
RUN mkdir /var/www/secure
COPY ./files-conf-static/index-secure.html /var/www/secure/index.html

# Set the correct time 
RUN apt-get install ntp ntpdate
RUN service ntp stop
RUN service ntp start

# Step 13 in the RNP tutorial
RUN sed -i 's/DAEMON_USER=_shibd/DAEMON_USER=root/g' /etc/init.d/shibd

RUN service apache2 start
RUN service shibd restart

WORKDIR /root
RUN mkdir files-conf-static
RUN mkdir files-conf-dinamic
RUN mkdir scripts
