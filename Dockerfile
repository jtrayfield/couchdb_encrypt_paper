FROM couchdb:2.1.1
RUN apt-get update -y
# install cryptsetup
RUN apt-get install -y --no-install-recommends cryptsetup
# make a place to mount the cleartext device
RUN mkdir /couchdb


