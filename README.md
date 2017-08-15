# Confluence
Docker container for Atlassian Confluence. This container includes all dependencies, listed in the Atlassian's "supported platforms" page, except a database. Please link a database by yourself.

## Reverse proxy settings
Use these environment variables, if you want to run a reverse proxy in front of the confluence service.

 * *CATALINA_CONNECTOR_PROXYNAME*: The reverse proxy's fully qualified hostname. (Default NONE)
 * *CATALINA_CONNECTOR_PROXYPORT*: The reverse proxy's port number via which confluence is accessed. (Default NONE)
 * *CATALINA_CONNECTOR_SCHEME*: The protocol via which confluence is accessed. (Default http)

## To use MS fonts for preview markos, set
```CATALINA_OPTS=-Dconfluence.document.conversion.fontpath=/usr/share/fonts/msttcore```
