#!/bin/bash

# Setting environment variables
TIMEZONE=${TIMEZONE:-"Europe/Paris"}

INFLUXDB_USERNAME=${INFLUXDB_USERNAME:-"admin"}
INFLUXDB_PASSWORD=${INFLUXDB_PASSWORD:-"password"}
INFLUXDB_ORG=${INFLUXDB_ORG:-"home-lab"}
INFLUXDB_BUCKET=${INFLUXDB_BUCKET:-"telegraf"}
INFLUXDB_RETENTION=${INFLUXDB_RETENTION:-"1w"}

#-------------------------------

# Function to generate a secure InfluxDB admin token
function generate_influxdb_admin_token() {
  gpg --gen-random -a 0 25
}

# Generation of the administration token
INFLUXDB_ADMIN_TOKEN=$(generate_influxdb_admin_token)

# Creating the .env file
cat << EOF > .env
TIMEZONE=$TIMEZONE

INFLUXDB_INIT_MODE=setup

# InfluxDB credentialsi
INFLUXDB_USERNAME=$INFLUXDB_USERNAME
INFLUXDB_PASSWORD=$INFLUXDB_PASSWORD

# InfluxDB organization and bucket
INFLUXDB_ORG=$INFLUXDB_ORG
INFLUXDB_BUCKET=$INFLUXDB_BUCKET

# InfluxDB retention period
INFLUXDB_RETENTION=$INFLUXDB_RETENTION

# InfluxDB admin token (highly sensitive, keep secret!)
INFLUXDB_ADMIN_TOKEN=$INFLUXDB_ADMIN_TOKEN
EOF

# Initializing the TICK stack
docker compose up -d

# Removal of setup mode
if [ "$(uname)" == "Darwin" ]; then
    sed -i "" "/INFLUXDB_INIT_MODE/d" .env
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sed -i "/INFLUXDB_INIT_MODE/d" .env
fi

echo "The TICK stack is initialized !"

