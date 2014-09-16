#/bin/sh

export JPDA_ADDRESS=8887
export JPDA_TRANSPORT=dt_socket
export JAVA_OPTS="-Xms512m -Xmx1024m"

exec /usr/local/tomcat/bin/catalina.sh jpda start 
