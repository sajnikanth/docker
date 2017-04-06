FROM selenium/node-chrome:3.0.1-carbon

MAINTAINER Sajnikanth "sajnikanth@gmail.com"

USER root

RUN  echo "deb http://archive.ubuntu.com/ubuntu xenial main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu xenial-updates main universe\n" >> /etc/apt/sources.list \
  && echo "deb http://security.ubuntu.com/ubuntu xenial-security main universe\n" >> /etc/apt/sources.list

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install software-properties-common \
  && add-apt-repository -y ppa:git-core/ppa

#===========================
# Set up to run python tests
#===========================
RUN apt-add-repository ppa:yandex-qatools/allure-framework \
 && apt-get update -y \
 && apt-get install \
  git curl python-pip\
  allure-commandline python-dev\
  python python-setuptools\
  libtiff5-dev libjpeg8-dev\
  zlib1g-dev libfreetype6-dev\
  liblcms2-dev libwebp-dev\
  tcl8.6-dev libxml2-dev\
  libxslt1-dev tk8.6-dev\
  python-tk build-essential -y

#========================================
# Add normal user with passwordless sudo
#========================================
RUN useradd jenkins --shell /bin/bash --create-home \
  && usermod -a -G sudo jenkins \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'jenkins:secret' | chpasswd

#============================
# Install virtual environment
#============================
USER jenkins
RUN pip install\
  virtualenv\
  virtualenvwrapper\
  autoenv\
  pip --upgrade

#====================
# Setup Jenkins Slave
#====================
USER root

ARG VERSION=2.62

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY jenkins-slave /usr/local/bin/jenkins-slave

RUN chmod a+rwx /home/jenkins
WORKDIR /home/jenkins

#====================================
# Scripts to run Selenium Standalone
#====================================
COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

USER jenkins

ENTRYPOINT ["/opt/bin/entry_point.sh","/usr/local/bin/jenkins-slave"]
EXPOSE 4444
