#!/bin/bash

# Check if script is running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit 1
fi

# Sistem bağımlılıkları
apt-get update
apt-get install -y gcc g++ python3 python3-pip swig

# Python bağımlılıkları
pip3 install -r requirements.txt
