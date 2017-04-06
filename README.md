Docker Image to run Python Tests
================================

It's an ubuntu machine with the following:

            add-apt-repository ppa:fkrull/deadsnakes-python2.7 &&\
            apt-add-repository ppa:yandex-qatools/allure-framework &&\
            apt-get update -y &&\
            apt-get install\
                git curl python-pip\
                allure-commandline python-dev\
                python python-setuptools\
                libtiff5-dev libjpeg8-dev\
                zlib1g-dev libfreetype6-dev\
                liblcms2-dev libwebp-dev\
                tcl8.6-dev libxml2-dev\
                libxslt1-dev tk8.6-dev\
                python-tk build-essential -y

Setup `virtualenv`
------------------
Install:

        sudo pip install\
            virtualenv\
            virtualenvwrapper\
            autoenv\
            pip --upgrade
