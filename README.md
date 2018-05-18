# Formio API Docker Container

Docker container for [Form.io](https://form.io)'s open-source [API Server](https://github.com/formio/formio) based on Alpine Linux.

### Usage

To start using this docker container just clone the repository and build it using docker-compose

```sh

git clone https://github.com/un-fao/fast-docker-api.git     # clone the repository
cd ./fast-docker-api                                        # change to cloned directory
cp template.env ./.env                                      # modify and save the .env file
docker network create <network_name>                        # create external network (formio by default)
docker-compose up -d                                        # fire-up the docker container
```

### Environment Configuration

The file `template.env` is provided as template for setting up the environment variables.  Once ready, save it as `.env` to build the docker image.