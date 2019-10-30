# Jobe-in-a-box: a Dockerised Jobe server (see https://github.com/trampgeek/jobe)
# With thanks to David Bowes (d.h.bowes@herts.ac.uk) who did all the hard work
# on this originally.

FROM ubuntu:18.04

LABEL maintainers="richard.lobb@canterbury.ac.nz,j.hoedjes@hva.nl"
ARG TZ=Pacific/Auckland
ARG ROOTPASS=jobeisfab
# Set up the (apache) environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV LANG C.UTF-8

# Copy apache virtual host file for later use
COPY 000-jobe.conf /

# Set timezone
# Install extra packages
# Redirect apache logs to stdout
# Configure apache
# Configure php
# Setup root password
# Get and install jobe
# Clean up
RUN ln -snf /usr/share/zoneinfo/"$TZ" /etc/localtime && \
    echo "$TZ" > /etc/timezone && \
    apt-get update && \
    apt-get --no-install-recommends install -yq tzdata \
      apache2 \
      php \
      libapache2-mod-php \
      php-cli \
      php-mbstring \
      octave \
      nodejs \
      build-essential \
      python3 \
      php-cli \
      fp-compiler \
      openjdk-11-jdk \
      python3-pip \
      pylint3 \
      sqlite3 \
      git \
      acl \
      unzip \
      sudo && \
    pylint3 --reports=no --score=n --generate-rcfile > /etc/pylintrc && \
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
    sed -i -e "s/export LANG=C/export LANG=$LANG/" /etc/apache2/envvars && \
    sed -i -e "1 i ServerName localhost" /etc/apache2/apache2.conf && \
    sed -i 's/ServerTokens\ OS/ServerTokens \Prod/g' /etc/apache2/conf-enabled/security.conf && \
    sed -i 's/ServerSignature\ On/ServerSignature \Off/g' /etc/apache2/conf-enabled/security.conf && \
    rm /etc/apache2/sites-enabled/000-default.conf && \
    mv /000-jobe.conf /etc/apache2/sites-enabled/ && \
    sed -i 's/expose_php\ =\ On/expose_php\ =\ Off/g' /etc/php/7.2/cli/php.ini && \
    mkdir -p /var/crash && \
    echo "root:$ROOTPASS" | chpasswd && \
    echo "Jobe" > /var/www/html/index.html && \
    git clone https://github.com/trampgeek/jobe.git /var/www/html/jobe && \
    apache2ctl start && \
    cd /var/www/html/jobe && ./install && \
    chown -R www-data:www-data /var/www/html && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    apt-get -y clean

# Expose apache
EXPOSE 80

# Start apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
