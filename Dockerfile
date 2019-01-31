# Jobe-in-a-box: a Dockerised Jobe server (see https://github.com/trampgeek/jobe)
# With thanks to David Bowes (d.h.bowes@herts.ac.uk) who did all the hard work
# on this originally.
# Version 2.1, 31 January 2019.

FROM ubuntu:18.04

LABEL maintainer="richard.lobb@canterbury.ac.nz"
ARG TZ=Pacific/Auckland
ARG ROOTPASS=jobeisfab

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -yq tzdata \
      apache2 php libapache2-mod-php php-cli php-mbstring octave nodejs \
      build-essential python3 php-cli fp-compiler \
      openjdk-11-jdk python3-pip pylint3 sqlite3 git acl unzip sudo && \
    pylint3 --reports=no --score=n --generate-rcfile > /etc/pylintrc

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV LANG C.UTF-8

# Now get jobe and install it
RUN cd /var/www/html && sudo git clone https://github.com/trampgeek/jobe.git && \
    cd /var/www/html/jobe && apache2ctl start && ./install

# Expose apache.
EXPOSE 80

RUN echo "root:$ROOTPASS" | chpasswd && \
    chown -R www-data /var/www/html && \
    sed -i -e "s/export LANG=C/export LANG=$LANG/" /etc/apache2/envvars && \
    sed -i -e "1 i ServerName localhost" /etc/apache2/apache2.conf

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
