FROM java:openjdk-8-jdk

# FROM openjdk:alpine
# 3.8.3 ee branch

MAINTAINER Brandon Grantham <brandon.grantham@gmail.com>


ADD ./runtime/mule-ee-distribution-standalone-3.8.3.zip /opt/
WORKDIR /opt
RUN unzip *.zip && cd /opt
RUN ln -s mule-enterprise-standalone-3.8.3 mule && rm -f mule-ee-distribution-standalone-3.8.3.zip
ADD ./*.lic /opt/mule/conf
RUN mule/bin/mule -installLicense mule/conf/mule-ee-license.lic && rm -f mule/conf/mule-ee-license.lic && rm -Rf examples

# Define environment variables.
ENV MULE_HOME /opt/mule

# Define mount points.
# VOLUME ["/opt/mule/logs", "/opt/mule/conf", "/opt/mule/apps", "/opt/mule/domains"]

# Define working directory.
WORKDIR /opt/mule

CMD [ "/opt/mule/bin/mule" ]

# Default http port
EXPOSE 8081
EXPOSE 8082
EXPOSE 8084
EXPOSE 8085
EXPOSE 8091
EXPOSE 8090