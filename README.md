Standalone Mule ESB Enterprise Docker Image
===============

This project contains a Dockerfile for the deployment and packaging of a standalone Mule ESB Enterprise with Docker.
This build is specific to Mule version 4.1.4.  Mule 4.2 to come soon. 

Preparing the Docker base image
---------------

Due to restrictions of the Enterprise version, the Docker image needs to be set up for individual usage beforehand. To run this as a licenced version of MuleSoft please install the license.
- Collect the Enterprise license file from MuleSoft
- Copy the license key (be sure to keep the original) in the source control main repo under the lic folder. 
- Be sure not to commit this license. It is difficult to invalidate the licesne if it is captured by a third party. 

Once the EE license is added to the github repo, run the build command.

The directory should look similar this (or the developer's preference):
* mule-ee/
* mule-ee/Dockerfile
(only include the mmc component if the dev intentds on deploying APIs)
* mule-ee/mmc-distribution-mule-console-bundle-4.1.4.zip

* mule-ee/conf/license.lic -- DO NOT COMMIT LICENSE TO GITHUB

Building and tagging the Docker base image
---------------

```bash
docker build --tag="mule-ee-414" .
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
ADD                     mule-app/target/mule-app-1.0.0-SNAPSHOT.zip /opt/mule-standalone-4.1.4/apps/
```

Build application specific Docker image:

```docker build --tag="my-mule-app-image" .
```

Start app specific image:

```docker run -t -i --name='mule-app-node' my-mule-app-image
```
### for example (including externally mountable apps  and logs directory):
```docker run -it --name='mule-ee-414' -v `pwd`/apps:/opt/mule/apps -v `pwd`/logs:/opt/mule/logs/ granthbr/mule-ee-414
```
This will embed the app in the application run time but, the app can still be overridden with a replacement if the app is removed from the app/ folder and replaced with another app. It is our preference to externally mount the log directory for the purpose of tailing the system/applicaiton log while the Mule container is running. If not needed, exclude the mount of the log/ directory.
