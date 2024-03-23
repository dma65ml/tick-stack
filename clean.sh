#!/bin/bash

# Removing stack and attached volumes
docker compose down -v

# Environment file deletions
rm .env

