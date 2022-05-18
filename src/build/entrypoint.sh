#!/bin/sh

set -e
user=ipfs

if [ `id -u` -eq 0 ]; then
    echo "Changing user to $user"
    # ensure directories are writable
    su-exec "$user" test -w "${IPFS_CLUSTER_PATH}" || chown -R -- "$user" "${IPFS_CLUSTER_PATH}"
    exec su-exec "$user" "$0" $@
fi

# Only ipfs user can get here
ipfs-cluster-service --version

if [ -e "${IPFS_CLUSTER_PATH}/service.json" ] && grep -q "$CLUSTER_SECRET" "${IPFS_CLUSTER_PATH}/service.json"; then
    echo "Found IPFS cluster configuration at ${IPFS_CLUSTER_PATH} with an empty secret or the same secret"
    grep "\"secret\":" "${IPFS_CLUSTER_PATH}/service.json"
else
    echo "Initializing default configuration..."
    ipfs-cluster-service init --force --consensus crdt
fi

if [ -z "${BOOTSTRAP_MULTIADDRESS}" ]; then
    exec ipfs-cluster-service daemon
else
    # Fallback to prevent infinite restarts
    exec ipfs-cluster-service daemon --bootstrap "${BOOTSTRAP_MULTIADDRESS}"
fi