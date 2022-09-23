FROM ubuntu:18.04

# Install command utilities
RUN apt-get update && apt-get install -y openssh-client make unzip git curl wget bash ca-certificates openssl coreutils gcc g++ grep util-linux binutils findutils libtool automake autoconf 
RUN apt-get install -y python3 python3-distutils && ln -sf python3 /usr/bin/python && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip \
  && unzip terraform_1.0.11_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_1.0.11_linux_amd64.zip

# Change permissions required for SSH or W
RUN mkdir /root/.ssh
RUN chmod 600 /root/.ssh

RUN mkdir /root/.aws
RUN chmod 600 /root/.aws

# Install AWS CLI
RUN wget --quiet https://s3.amazonaws.com/aws-cli/awscli-bundle-1.22.16.zip \
  && unzip awscli-bundle-1.22.16.zip \
  && ./awscli-bundle/install -i /usr/local/aws -b /usr/bin/aws

# COPY ../ /app

WORKDIR /app

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash


# Install latest Node LTS
RUN export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install v14.20.0 && nvm use v14.20.0
RUN apt-get update
RUN apt-get install -y build-essential