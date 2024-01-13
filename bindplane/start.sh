#!/bin/bash

set -e

cd $(dirname $0)

# Container user ids
prometheus_uid=65534
postgres_uid=999
kafka_uid=1001

# Create the data directories that will
# be mounted into the containers.
#
# Sudo is required because the directories
# may already exist with different ownership
# than the current user. 
configure_directory() {
  sudo sudo mkdir -p \
    data/prometheus \
    data/postgres \
    data/kafka
}

# Ensure the directories are owned by the
# correct user. This is required because
# because each container's process runs as
# a different user id.
#
# Sudo is required because the directories
# may already exist and be owned by a different
# user.
configure_permissions() {
  sudo chown -R $prometheus_uid data/prometheus
  sudo chown -R $postgres_uid data/postgres
  sudo chown -R $kafka_uid data/kafka
}

configure_directory
configure_permissions
docker-compose up -d
