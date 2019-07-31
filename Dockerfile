FROM atlassian/confluence-server:6.15.7-ubuntu-18.04-adoptopenjdk8
LABEL maintainer="sysadmin@flowable.com"

# install dependencies for PlantUML plugin
RUN apt-get update -y && \
    apt-get install -y graphviz &&
    apt-get clean