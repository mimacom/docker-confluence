###
FROM atlassian/confluence-server:7.4.7
LABEL maintainer="sysadmin@flowable.com"

# install dependencies for PlantUML plugin
RUN apt-get update -y && \
    apt-get install -y graphviz && \
    apt-get clean
