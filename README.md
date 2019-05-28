Standalone Mule ESB Enterprise Docker Image
===============

This project contains a Dockerfile for the deployment and packaging of a standalone Mule ESB Enterprise with Docker.
This build is specific to Mule version 4.1.1.  Mule 4.2 to come soon. 

Preparing the Docker base image
---------------

Due to restrictions of the Enterprise version, the Docker image needs to be set up for individual usage beforehand. To run this as a licenced version of MuleSoft please install the license.
- provide the Enterprise license file from Mulesoft, located in the source control main repo under the cong folder. There is a placeholder in github. It can be ignored or removed. It needed to be there for the directory to be committed.
Once the EE license is added to the github repo, run the build command.

The directory should look similar this (or the developer's preference):
* mule-ee/
* mule-ee/Dockerfile
(only include the mmc component if the dev intentds on deploying APIs)
* mule-ee/mmc-distribution-mule-console-bundle-4.1.1.zip

* mule-ee/conf/license.lic -- DO NOT COMMIT LICENSE TO GITHUB

Building and tagging the Docker base image
---------------

```bash
docker build --tag="mule-ee-411" .
```

Image types
---------------

There are two ways now to use the Docker images, depending on the overall scenario:

- you can use the base images to startup and create a classical standalone Mule ESB instances and one MMC instance. These can be used as a cluster as usual with hot deployment over MMC etc.

- or, which we recommend, create an Docker image for each Mule ESB application to isolate the applications from each other, startup and create multiple standalone Mule ESB instances and one MMC instance. This might be a an option for micro-service and fronting the micro-service with an interface. 

Standalone Mule ESB Enterprise Container
---------------

Start a standalone Mule ESB Enterprise instance

``` docker run -t -i --name='mule-ee-nodeX' mule-ee
```

Expose the applicaiton folder in the github repo when running the container (apps/)
``` -v `pwd`/apps:/opt/mule/apps
```
App specific container image
---------------

```#!/bin/bash
FROM                    mule-ee:latest
.
.
ADD                     mule-app/target/mule-app-1.0.0-SNAPSHOT.zip /opt/mule-standalone-4.1.1/apps/
```

Build application specific Docker image:

```docker build --tag="my-mule-app-image" .
```

Start app specific image:

```docker run -t -i --name='mule-app-node' my-mule-app-image
```
### for example (including externally mountable apps directory):
```docker run -it --name='mule-ee-411' -v `pwd`/apps:/opt/mule/apps granthbr/mule-ee-411
```
