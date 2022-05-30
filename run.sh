#!/usr/bin/env bash

AW_HOSTNAME=$(hostname)

if [ -n "$1" ]; then
  TAGS="--tags=$1"
else
  TAGS=""
fi

ansible-playbook $TAGS --ask-become-pass --vault-password-file=vpw --limit=${AW_HOSTNAME} -i workstations.yml workstation.yml
