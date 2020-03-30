#!/bin/sh

set -e

if [ "$HMAC_SECRET_KEY" == "" ]; then
    echo "HMAC_SECRET_KEY not set. Exiting.."
    exit 1
fi

if [ "$API_KEY" == "" ]; then
    echo "API_KEY not set. Exiting.."
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
  "token_hmac_secret_key": "$HMAC_SECRET_KEY",
  "api_key": "$API_KEY",
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
