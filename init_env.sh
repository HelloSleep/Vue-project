#!/bin/bash
LOCAL_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
echo "LOCAL_HOSTNAME=$LOCAL_HOSTNAME" > .env

LOCAL_IPV4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "LOCAL_IPV4=$LOCAL_IPV4" >> .env

VUE_APP_API_URL=http://${LOCAL_HOSTNAME}:3000/api/
echo "VUE_APP_API_URL=$LOCAL_HOSTNAME" > .env

REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region)
echo "REGION=$REGION" >> .env

AVAILABILITY_ZONE=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "AVAILABILITY_ZONE=$AVAILABILITY_ZONE" >> .env