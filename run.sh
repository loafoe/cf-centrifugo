#!/bin/sh

set -e

if [ "$SECRET" == "" ]; then
    echo "SECRET not set. Exiting.."
    exit 1
fi

if [ "$ADMIN_PASSWORD" == "" ]; then
    echo "ADMIN_PASSWORD not set. Exiting.."
    exit 1
fi

if [ "$ADMIN_SECRET" == "" ]; then
    echo "ADMIN_SECRET not set. Exiting.."
    exit 1
fi

if [ -z $PORT ]; then
   PORT=8080
fi

cat <<EOF > config.json
{
  "secret": "$SECRET",
  "admin": true,
  "admin_password": "$ADMIN_PASSWORD",
  "admin_secret": "$ADMIN_SECRET",
  "web": true,
  "namespaces": [
    {
      "name": "public",
      "anonymous": true,
      "publish": true,
      "watch": true,
      "presence": true,
      "join_leave": true,
      "history_size": 10,
      "history_lifetime": 30,
      "recover": true
    }  
  ]
}
EOF

echo "#### Starting Centrifugo..."

./centrifugo -p $PORT --admin --config=config.json
