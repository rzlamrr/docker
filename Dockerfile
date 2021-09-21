# set base image (host OS)
FROM python:3.9

ENV DEBIAN_FRONTEND=noninteractive \
    GOOGLE_CHROME_DRIVER=/usr/bin/chromedriver \
    GOOGLE_CHROME_BIN=/usr/bin/google-chrome-stable

RUN apt -qqy update && \
    apt -qqy install --no-install-recommends \
    curl \
    git \
    gnupg2 \
    unzip \
    wget \
    ffmpeg \
    jq \
    screen

# install chrome
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    # -f ==> is required to --fix-missing-dependancies
    dpkg -i ./google-chrome-stable_current_amd64.deb; apt -fqqy install && \
    # clean up the container "layer", after we are done
    rm ./google-chrome-stable_current_amd64.deb

# install chromedriver
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget -q -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip  && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ && \
    # clean up the container "layer", after we are done
    rm /tmp/chromedriver.zip

# install rar
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget -q -O /tmp/rarlinux.tar.gz http://www.rarlab.com/rar/rarlinux-x64-6.0.0.tar.gz && \
    tar -xzvf rarlinux.tar.gz && \
    cd rar && \
    cp -v rar unrar /usr/bin/ && \
    # clean up
    rm -rf /tmp/rar*

# install dependencies
RUN wget -q -O requirements.txt https://raw.githubusercontent.com/UsergeTeam/Userge/alpha/requirements.txt \
    && pip install -r requirements.txt
