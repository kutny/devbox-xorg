FROM ubuntu:16.10
MAINTAINER Pawel Panasewicz

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
 apt-transport-https \
 curl \
 wget \
 telnet \
 vim \
 openssh-server \
 npm \
 firefox \
 sudo

#xpra and it's dependencies
RUN curl https://xpra.org/gpg.asc | apt-key add -
RUN echo "deb https://xpra.org/ yakkety main" > /etc/apt/sources.list.d/xpra.list
RUN apt-get update -y \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 xpra \
 python-dbus \
 xserver-xorg \
 xorg \
 dbus-x11 \
 xserver-xorg-video-dummy

RUN mkdir -p /var/run/xpra
RUN chown :xpra /var/run/xpra
RUN chmod g+w /var/run/xpra

# Upstart and DBus have issues inside docker. We work around in order to install firefox.
#(Roberto G. Hashioka - docker-desktop)
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl


#create user devbox
RUN adduser --disabled-password --gecos "" devbox && mkdir /home/devbox/.ssh/ && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAplYCUmejMDvV5bsa7K6RbFYc9385LEwy1wG5Ig5anFanhilLkfG3yLPD53AkdcbGMykimyK37chC3F102U3UiEn/Aa/DwQTyutiTuflDIE17ckuwWL8LTJXj037HFuEF1JuNdpzu3mJ8H5uhonMYTGbUsTD1KfvRnhJ6wUJanQLBw/o+rZWKZBk55R4KQsm4o60lWwTjSV20SkxtqGqaMs+PcJoSkde9ecpRnMJn/c83L0+P8b5YhGkeBrbW16Rldf7w8N54v8XZj8otrjaX7m8LAo3hS9D6iDnnX75qfnMnMGIvvaeC1K93YizLzw/J0tco9KD+0VWeXpHh7QPc4Q== koutny@collabim.com" >> /home/devbox/.ssh/authorized_keys

RUN usermod -a -G sudo,xpra,tty,video,dialout  devbox #add devbox user to groups

ENV TZ=Europe/Prague

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common wget git curl graphviz openjdk-8-jre libxext-dev libxrender-dev libxtst-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN mkdir /home/devbox/.PhpStorm2016.3 \
    && touch /home/devbox/.PhpStorm2016.3/.keep \
	&& chown -R devbox:devbox /home/devbox/.PhpStorm2016.3/ \
	&& mkdir /home/devbox/workspace \
	&& chown -R devbox:devbox /home/devbox/workspace/ \
    && mkdir /opt/phpstorm \
    && wget -O - https://download.jetbrains.com/webide/PhpStorm-2016.3.2.tar.gz | tar xzf - --strip-components=1 -C "/opt/phpstorm"

RUN apt-get update && apt-get install firefox

RUN apt-get update \
    && apt-get install -y avahi-daemon python3-setuptools python3-dev \
    && easy_install3 pip \
    && pip3 install netifaces \
    && pip3 install xxhash

#run ssh service
RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
