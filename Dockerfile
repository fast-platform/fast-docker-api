# Use alpine-node image with nodejs v8
FROM mhart/alpine-node:6

# Intsall dependencies
RUN apk add --no-cache openrc make gcc g++ python nginx git ca-certificates wget

# Fix missing directories in alpine for nginx
RUN mkdir -p /tmp/nginx/client-body && mkdir -p /run/nginx

# Clone Form.io server
RUN git clone https://github.com/formio/formio.git /src/formio

# Define the working directory
WORKDIR /src/formio

# Install packages
RUN npm install

# Fix for connecting to Mongodb Atlas cluster
RUN npm remove mongoose && npm install mongoose@5.0.15

# Copy the templates directory
COPY templates ./templates

# Download default Form.io project template
RUN wget https://raw.githubusercontent.com/formio/formio-app-formio/master/dist/project.json -O ./templates/project.default.json

# Copy configuration and scripts
COPY config ./config
COPY scripts/* ./

# Copy nginx configuration and ssl certificate directory
COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl /etc/nginx/ssl

# Clean-up
RUN rm -rf /var/cache/apk/*

CMD [ "sh", "./start.sh"]