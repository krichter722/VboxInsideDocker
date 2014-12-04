# VirtualBox 4.3.10
#
# VERSION               0.0.1

FROM ubuntu:14.04
MAINTAINER Jean-Christophe Proulx <j.christophe@devjc.net>

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


# We install VirtualBox
RUN sudo apt-get install linux-headers-generic virtualbox-dkms
RUN sudo /etc/init.d/virtualbox status
RUN cd /tmp
RUN wget http://download.virtualbox.org/virtualbox/4.3.10/Oracle_VM_VirtualBox_Extension_Pack-4.3.10-93012.vbox-extpack
RUN sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-4.3.10-93012.vbox-extpack

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
