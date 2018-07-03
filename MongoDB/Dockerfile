FROM mongo:latest

LABEL maintainer="Ignacio Cabrera <cabrerabywaters@gmail.com>"

################################################################
# If required, you can include your own mongo.conf
# just uncomment the next line and include
# the file into the MongoDB folder
################################################################

COPY setup.sh /docker-entrypoint-initdb.d

VOLUME /data/db /data/configdb

CMD ["mongod"]

EXPOSE 27017
