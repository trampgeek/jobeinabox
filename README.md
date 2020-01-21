# jobeinabox

The [Moodle CodeRunner question type plugin](https://moodle.org/plugins/qtype_coderunner) requires a Jobe server on which to run student-submitted jobs. This Docker image provides a basic Jobe server that runs all the standard languages but does not have a mysql server installed so cannot use API-key access. For normal use, that's not a problem - API-key access is relevant only to Jobe servers delivering services to multiple clients.

Thanks to David Bowes who set up the first version of this.

## Using jobeinabox

To run the pre-built docker hub image (but please read the warnings below, first):

    sudo docker run -d -p 4000:80 --name jobe trampgeek/jobeinabox:latest

Be warned that it's over 1 GB, so may take a long time to start the first time, depending on your download bandwidth.

You can check it's running OK by browsing to

     http://[host_running_docker]:4000/jobe/index.php/restapi/languages
and you should get a JSON-encoded list of the supported languages, namely

    [["c","7.3.0"],["cpp","7.3.0"],["java","10.0.2"],["nodejs","8.10.0"],["octave","4.2.2"],["pascal","3.0.4"],["php","7.2.7"],["python3","3.6.5"]]

If you wish to run the test suite within the container, use the command

    docker exec -t jobe /usr/bin/python3 /var/www/html/jobe/testsubmit.py

To set your Moodle/CodeRunner plugin to use this dockerised Jobe server, set the Jobe server field in the CodeRunner admin settings (Site Administration > Plugins > Question types > CodeRunner) to

    [host_running_docker]:4000

Do not put http:// at the start.

To stop the running server, enter the command

    docker stop jobe

### Warnings:

1. The pre-built image has a publicly-visible root password. Use it only
   for in-house or testing purposes. For production use you should build your
   own image with a different password and timezone, as in the next section.

1. Note that while the container in which this Jobe runs should be secure, the container's network is currently just bridged across to the host's network. This means that Jobe can be accessed from anywhere that can access the host and can access any URI that the host can access. Firewalling of the host is essential for production use.


## Building your own image locally (strongly recommended)

For production use you should build your own image, configured with an
unguessable password and the local timezone, as follows.

Pull this repo from github, cd into the jobeinabox directory and type a command
of the form

    docker build . -t my/jobeinabox --build-arg TZ="Europe/Amsterdam" --build-arg ROOTPASS="complicated_password"

You can then run your newly-built image with the command

    sudo docker run -d -p 4000:80 --name jobe my/jobeinabox

This will give you a jobe server running on port 4000, which can then be
tested locally and used by Moodle as in the previous section.

The warning about networking in the previous section still applies to this
locally-build image.
