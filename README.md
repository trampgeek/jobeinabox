# jobeinabox

The [Moodle CodeRunner question type plugin](https://moodle.org/plugins/qtype_coderunner) requires a [Jobe server](https://github.com/trampgeek) on which to run student-submitted jobs. [JobeInABox](https://hub.docker.com/r/trampgeek/jobeinabox/) is a Docker image that provides a basic Jobe server that runs all the standard languages but does not have a mysql server installed so cannot use API-key access. For normal use, that's not a problem - API-key access is relevant only to Jobe servers delivering services to multiple clients.

## Using jobeinabox

To run this ready-to-go image, you need to have docker installed on your machine.
Then just type the command

    docker run -p 4000:80 trampgeek/jobeinabox:latest

This will start a Jobe server on port 4000.

You can check it's running by browsing to

    <servername>:4000/jobe/index.php/restapi/languages

and you should see a json-encoded list of languages supported by this particular
jobe server.

Assuming you are running Jobe
as a Moodle/CodeRunner server, you can then configure the CodeRunner plugin
to use this Jobe server by logging into Moodle as an administrator, going to

    Dashboard > Site administration > Plugins > Question types > CodeRunner

and setting the *Jobe server* field to

    <servername>:4000


## Building your own image locally.

The docker image is autobuilt on [DockerHub]((https://hub.docker.com/r/trampgeek/jobeinabox/). If you wish to
build your own version locally, make sure you have docker and docker-compose installed. Then pull this repo from github, cd into the jobeinabox directory and edit docker-compose.yml to suit your own needs. Then simply build the image with the command

    docker-compose build

Or with a different timezone:

    docker-compose build --build-arg TZ="Europe/Amsterdam"

And with a different root password (please do since the source is open):

    docker-compose build --build-arg --build-arg TZ="Europe/Amsterdam" --build-arg ROOTPASS="complicated_password"

You can then run your newly-built image with the command

    docker-compose up

which, as above, will give you a jobe server running on port 4000.





