FROM google/debian:wheezy
ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION 7u79
ENV JAVA_DEBIAN_VERSION 7u79-2.5.5-1~deb8u1

RUN apt-get update \
        && apt-get install -y -qq --no-install-recommends \ 
        wget \
        curl \
        unzip \
        python \
        openjdk-7-jre \
        openssh-client \
        python-openssl \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Begin - Google Cloud SDK

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --disable-installation-options
RUN google-cloud-sdk/bin/gcloud --quiet components update pkg-go pkg-python pkg-java preview alpha beta app
RUN google-cloud-sdk/bin/gcloud --quiet config set component_manager/disable_update_check true
RUN mkdir /.ssh
ENV PATH /google-cloud-sdk/bin:$PATH
ENV HOME /
VOLUME ["/.config"]
CMD ["/bin/bash"]

# End - Google Cloud SDK

# Begin - Java openjdk-7-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

# End - Java openjdk-7-jdk
