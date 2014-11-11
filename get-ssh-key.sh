#!/bin/bash
ATTEMPTS=10

mkdir -p /root/.ssh
chmod 700 /root/.ssh

TMPFILE=$(mktemp)
while [ ! -f /root/.ssh/authorized_keys ] && [ ${ATTEMPTS} -gt 0 ]; do
  ATTEMPTS=$((${ATTEMPTS}-1))
  curl -sf http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key \
    > ${TMPFILE} 2>/dev/null
  if [ $? -eq 0 ]; then
    cat ${TMPFILE} >> /root/.ssh/authorized_keys
    chmod 0600 /root/.ssh/authorized_keys
    echo "Successfully retrieved public key from instance metadata"
    echo "********************************************************"
    echo "AUTHORIZED KEYS"
    echo "********************************************************"
    cat /root/.ssh/authorized_keys
    echo
    echo "********************************************************"
  fi
  sleep 1
done
rm -f ${TMPFILE}
