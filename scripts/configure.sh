s hostname is the domain related with the Service Provider on CAFE RNP
HOSTNAME_SERVICE_PROVIDER='naf.fogbowcloud.org'
ID_CONTAINER=a719434a1d09

DEFAULT_NAME_TO_REPLACE_ADDRESS_SHIBBOLETH_AUTH_APPLICATION='_ADDRESS_SHIBBOLETH_AUTH_APPLICATION_'
DEFAULT_NAME_TO_REPLACE_HOSTNAME='_HOSTNAME_'

# Moving and Normalizing the default configuration path in the container
APACHE_DEFAULT_CONFIG_FILE_FULL_PATH='/etc/apache2/sites-available/default.conf'
sudo docker cp default.conf $ID_CONTAINER:$APACHE_DEFAULT_CONFIG_FILE_FULL_PATH
sudo docker exec -it $ID_CONTAINER /bin/bash -c 'sed s/$DEFAULT_NAME_TO_REPLACE_HOSTNAME/$HOSTNAME_SERVICE_PROVIDER/g $APACHE_DEFAULT_CONFIG_FILE_FULL_PATH'

sudo docker cp shibboleth-sp2.conf $ID_CONTAINER:/etc/apache2/sites-available/shibboleth-sp2.conf
sudo docker cp shibboleth2.xml $ID_CONTAINER:/etc/shibboleth/shibboleth2.xml

sudo docker cp naf.fogbowcloud.org.crt $ID_CONTAINER:/etc/ssl/certs/
sudo docker cp naf.fogbowcloud.org.key $ID_CONTAINER:/etc/ssl/private/

sudo docker exec -it $ID_CONTAINER a2ensite shibboleth-sp2.conf

sudo docker exec -it $ID_CONTAINER service apache2 start
sudo docker exec -it $ID_CONTAINER service apache2 reload
sudo docker exec -it $ID_CONTAINER service shibd restart
