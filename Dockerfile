FROM jenkins/jenkins
USER root
RUN apt-get update && \
      apt-get -y install \
      ruby-dev \
	   zlib1g-dev \
	   apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common && \
   curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
   add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) stable" && \
   gem install bundler && \
   apt-get update && \
   apt-get -y install docker-ce && \
   curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose && \
   chmod +x /usr/bin/docker-compose

USER jenkins