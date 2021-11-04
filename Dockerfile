FROM tomcat:8.0-alpine
ADD /home/ubuntu/src/target/hello-1.0.war /usr/local/tomcat/webapps/
