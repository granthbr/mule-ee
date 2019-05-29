FROM java:openjdk-8-jdk

# 4.2 ee branch

MAINTAINER Brandon Grantham <brandon.grantham@mulesoft.com>

# # Define environment variables.
ENV MULE_HOME /opt/mule
ENV LICENSE_FILE /opt/mule/conf/license.lic
# working dir
WORKDIR /opt
# create mule user and group
RUN useradd --user-group --shell /bin/false mule && chown mule /opt 
USER mule
# get mule ee runtime
RUN wget https://s3.amazonaws.com/new-mule-artifacts/mule-ee-distribution-standalone-4.2.zip \
	&& unzip *.zip \
	&& ln -s mule-enterprise-standalone-4.2 mule && rm mule-ee-distribution-standalone-4.2.zip

# to add a license insert the following line
ADD lic/license.lic $MULE_HOME/conf/license.lic
ADD ./start.sh $MULE_HOME/
# to complete the license install uncomment the next line
RUN set -x \
	&& $MULE_HOME/bin/mule -installLicense $MULE_HOME/conf/license.lic 
	# && rm -f mule/conf/mule-ee-license.lic && rm -Rf examples
# # Define mount points.
VOLUME ["/opt/mule/logs", "/opt/mule/conf", "/opt/mule/apps", "/opt/mule/domains"]
#
# Define working directory.
WORKDIR /opt/mule
#
CMD [ "./start.sh" ]

# # Default http port
EXPOSE 8081
EXPOSE 8082
EXPOSE 8084
EXPOSE 8085
EXPOSE 8091
EXPOSE 8090