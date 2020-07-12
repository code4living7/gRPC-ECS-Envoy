#!/bin/sh
set -e

echo "Generating envoy.yaml config file..."
cat /tmpl/envoy.yml | envsubst \$LISTEN_PORT,\$SERVICE_DISCOVERY_ADDRESS,\$SERVICE_DISCOVERY_PORT > /etc/envoy.yaml

/usr/local/bin/envoy -c /etc/envoy.yaml
