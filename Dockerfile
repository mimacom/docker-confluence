FROM centos:7
MAINTAINER sysadmin@mimacom.com

# Setup useful environment variables
ENV CONFLUENCE_HOME     /var/atlassian/application-data/confluence
ENV CONFLUENCE_INSTALL  /opt/atlassian/confluence
ENV CONF_VERSION 5.9.14

LABEL Description="This image is used to start Atlassian Confluence" Vendor="Atlassian" Version="${CONF_VERSION}"

ENV CONFLUENCE_DOWNLOAD_URL http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONF_VERSION}.tar.gz

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
ENV RUN_USER            daemon
ENV RUN_GROUP           daemon


# download oracle jre8
RUN yum update -y && \
    yum install -y wget && \
    rm -rf /var/cache/yum/* && \
    mkdir -p /opt/java && \
    wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jre-8u121-linux-x64.tar.gz" -O /opt/jre.tar.gz && \
    tar xfv /opt/jre.tar.gz -C /opt/java/ --strip-components=1 && \
    rm -f /opt/jre.tar.gz

# add java to PATH
COPY java.sh /etc/profile.d/java.sh

# download confluence
RUN mkdir -p "${CONFLUENCE_HOME}" && \
    chmod -R 700 "${CONFLUENCE_HOME}" &&\
    chown ${RUN_USER}:${RUN_GROUP} "${CONFLUENCE_HOME}" && \

    mkdir -p "${CONFLUENCE_INSTALL}/WEB-INF/classes/" && \
    curl -Ls "${CONFLUENCE_DOWNLOAD_URL}" | tar -xz --directory "${CONFLUENCE_INSTALL}" --strip-components=1 --no-same-owner && \

    chmod -R 700 "${CONFLUENCE_INSTALL}" && \
    chown -R ${RUN_USER}:${RUN_GROUP} "${CONFLUENCE_INSTALL}" && \
    echo -e "\nconfluence.home=${CONFLUENCE_HOME}" >> "${CONFLUENCE_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties"

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
#USER ${RUN_USER}:${RUN_GROUP}

# Expose default HTTP connector port.
EXPOSE 8090
#EXPOSE 8091

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["${CONFLUENCE_INSTALL}", "${CONFLUENCE_HOME}"]

# Set the default working directory as the Confluence installation directory.
WORKDIR ${CONFLUENCE_INSTALL}

# Run Atlassian Confluence as a foreground process by default.
#CMD ["./bin/catalina.sh", "run"]
#ENTRYPOINT ["./bin/catalina.sh" ]

    


# install the entrypoint
COPY entrypoint /entrypoint
RUN chmod 755 /entrypoint

# start
ENTRYPOINT ["/entrypoint"]
