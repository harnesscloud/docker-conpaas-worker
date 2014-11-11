#!/bin/bash
# obviously, this isn't quite as complicated as the my_init provided by phusion
# baseimage...

if [ -d /etc/my_init.d ]; then
    ls /etc/my_init.d/* | sort | while read SCRIPT; do
        if [ -x ${SCRIPT} ]; then
            ${SCRIPT}
        else
            /bin/bash ${SCRIPT}
        fi
    done
fi

exec /usr/sbin/runsvdir-start
