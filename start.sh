#!/bin/sh

#tor &
#/nezha -config /nezha.json &
#caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

tor > /dev/null 2>&1 &
/nezha -config /nezha.json > /dev/null 2>&1 &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile > /dev/null 2>&1
