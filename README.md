# jobeinabox

The [Moodle CodeRunner question type plugin](https://moodle.org/plugins/qtype_coderunner) requires a Jobe server on which to run student-submitted jobs. This Docker image provides a basic Jobe server that runs all the standard languages but does not have a mysql server installed so cannot use API-key access. For normal use, that's not a problem - API-key access is relevant only to Jobe servers delivering services to multiple clients.

Thanks to David Bowes who set up the first version of this.

## Using jobeinabox

To run:

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

Note that while the container in which this Jobe runs should be secure, the container's network is currently just bridged across to the host's network. This means that Jobe can be accessed from anywhere that can access the host and can access any URI that the host can access. Firewalling of the host is essential for production use.


## Building your own image locally.

If you wish to
build your own version locally, make sure you have docker and docker-compose installed. Then pull this repo from github, cd into the jobeinabox directory and edit docker-compose.yml to suit your own needs. Then simply build the image with the command

    docker-compose build

Or with a different timezone:

    docker-compose build --build-arg TZ="Europe/Amsterdam"

And with a different root password (strongly advised, since the source is open):

    docker-compose build --build-arg --build-arg TZ="Europe/Amsterdam" --build-arg ROOTPASS="complicated_password"

You can then run your newly-built image with the command

    docker-compose up

which, as above, will give you a jobe server running on port 4000.





