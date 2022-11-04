#!/usr/bin/bash
docker-compose down
pkill -f "kubectl port-forward"
pkill -f "stack-up.sh"