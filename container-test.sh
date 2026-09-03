#!/bin/bash

# exit if any command has a non-zero exit status
set -e

echo "Verifying privileged helper ownership/permissions"
# www-data runs these as root via sudoers, so www-data must NOT be able to
# overwrite them. install(1) leaves them root:root mode 700.
for helper in runguard rmjobedir; do
    perms=$(stat -c '%U:%G %a' "/var/www/html/jobe/runguard/$helper")
    if [ "$perms" != "root:root 700" ]; then
        echo "INSECURE /var/www/html/jobe/runguard/$helper: $perms (expected root:root 700)"
        exit 1
    fi
done

echo "Starting Apache in the background"
/usr/sbin/apache2ctl -D BACKGROUND

echo "Start testsubmit.py as user www-data"
su -s /bin/bash -c "/usr/bin/python3 /var/www/html/jobe/testsubmit.py" www-data
