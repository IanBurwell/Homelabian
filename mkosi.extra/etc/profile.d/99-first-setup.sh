#!/bin/bash

# Wrapper bash script to run the first setup python script

if [ ! -f /var/lib/.homelabian-setup ]; then

    echo "\nStarting homelabian first time setup..."
    sudo /usr/local/bin/homelabian-first-setup.py

    if [ ! -f /var/lib/.homelabian-setup ]; then
        echo "!!! Homelabian setup script exited without completing !!!!"
        echo "To retry, re-login or run /etc/profile.d/99-first-setup.sh"
    fi

fi