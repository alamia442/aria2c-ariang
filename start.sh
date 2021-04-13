#!/bin/bash
bash setup.sh
if [ -f .env ]; then
    echo ".env file found, sourcing it"
	set -o allexport
	source .env
	set +o allexport
fi

export PATH="$(cat PATH)"

if [[ -n $RCLONE_CONFIG && -n $RCLONE_DESTINATION ]]; then
	echo "Rclone config detected"
	echo -e "[DRIVE]\n$RCLONE_CONFIG" > /app/rclone.conf
	echo "on-download-stop=/app/delete.sh" >> /app/aria2c.conf
	echo "on-download-complete=/app/on-complete.sh" >> /app/aria2c.conf
	chmod +x /app/delete.sh
	chmod +x /app/on-complete.sh
fi

echo "rpc-secret=$ARIA2C_SECRET" >> /app/aria2c.conf
aria2c --conf-path=/app/aria2c.conf&
yarn start
