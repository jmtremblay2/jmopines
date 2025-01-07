#!/bin/bash
set -x
set -e

sudo cp -f jmopines.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable jmopines
sudo systemctl start jmopines