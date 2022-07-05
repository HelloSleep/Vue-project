#!/bin/bash
PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
echo "PUBLIC_HOSTNAME=$PUBLIC_HOSTNAME" > .env.prod

PUBLIC_IPV4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "PUBLIC_IPV4=$PUBLIC_IPV4" >> .env.prod

VUE_APP_API_URL=http://${PUBLIC_HOSTNAME}:3000/api/
echo "VUE_APP_API_URL=$VUE_APP_API_URL" >> .env.prod

REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region)
echo "REGION=$REGION" >> .env.prod

AVAILABILITY_ZONE=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "AVAILABILITY_ZONE=$AVAILABILITY_ZONE" >> .env.prod