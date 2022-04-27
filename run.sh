#!/usr/bin/env bash

if [ -n "$1" ]; then
  TAGS="--tags=$1"
else
  TAGS=""
fi

ansible-playbook $TAGS --ask-become-pass --vault-password-file=vpw -i workstations.yml workstation.yml
