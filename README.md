# jobeinabox

The [Moodle CodeRunner question type plugin](https://moodle.org/plugins/qtype_coderunner) requires a [Jobe server](https://github.com/trampgeek) on which to run student-submitted jobs. [JobeInABox](https://hub.docker.com/r/trampgeek/jobeinabox/) is a Docker image that provides a basic Jobe server that runs all the standard languages but does not have a mysql server installed so cannot use API-key access. For normal use, that's not a problem - API-key access is relevant only to Jobe servers delivering services to multiple clients.

If you're looking for the ready to run Docker image itself, you'll find it [in the DockerHub repo](https://hub.docker.com/r/trampgeek/jobeinabox/). This GitHub repository is relevant only if you wish to build your own
customised Docker image.

To build a docker image, make sure you have docker and docker-comose installed. Then pull this repo, cd into the jobeinabox directory and edit docker-compose.yml to suit your own needs. Then simply build the image with the command

    docker-compose build
    
Instructions for using the image are on [DockerHub]((https://hub.docker.com/r/trampgeek/jobeinabox/)
