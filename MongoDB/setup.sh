#!/bin/bash
USER=$MONGO_DB_USER
PASS=$MONGO_DB_PASSWORD
DB=$MONGO_INITDB_DATABASE

# Create User
echo "Creating user: \"$USER\"..."
mongo $DB --eval "db.createUser({ user: '$USER', pwd: '$PASS', roles: ['readWrite', 'dbAdmin'] });"
mongo $DB --eval "db.createCollection('log', { capped: true, size: 5242880, max: 5000 });"
echo "========================================================================"
echo "MongoDB User: \"$USER\""
echo "MongoDB Password: \"$PASS\""
echo "MongoDB Database: \"$DB\""
echo "========================================================================"
