# generate a random password
RD_PASS=$(openssl rand -base64 16)

# show unencrypted password
echo ${RD_PASS}

# change default rundeck admin password
sed -i "s/^admin:admin/admin:${RD_PASS}/g" /etc/rundeck/realm.properties
# restart rundeck
service rundeckd restart
