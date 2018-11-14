# Start with ubuntu 16.04
FROM ubuntu:16.04

MAINTAINER Alex Kisakye kisakye@gmail.com

# For SSH access and port redirection
ENV ROOTPASSWORD sample

# Turn off prompts during installations
#ENV DEBIAN_FRONTEND noninteractive
#RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
#RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# Update packages
RUN apt-get clean
RUN apt-get -y update

# Install system tools / libraries
RUN apt-get -y install postfix

# Run sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo "root:$ROOTPASSWORD" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Expose Node.js app port
EXPOSE 22,25

RUN systemctl enable postfix
RUN systemctl start postfix
