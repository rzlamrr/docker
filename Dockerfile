FROM rzlamrr/megasdk:bullseye

EXPOSE 80

ENV DEBIAN_FRONTEND=noninteractive GOOGLE_CHROME_DRIVER=/usr/bin/chromedriver GOOGLE_CHROME_BIN=/usr/bin/google-chrome-stable

RUN apt -qqy update && \
    apt -qqy install --no-install-recommends \
    aria2 screen && \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i ./google-chrome-stable_current_amd64.deb; apt -fqqy install && \
    rm ./google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt -qqy autoclean && apt -qqy autoremove

RUN mkdir -p /tmpk/ && \
    cd /tmpk/ && \
    # install chromedriver
    wget -q -O chromedriver.zip http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip  && \
    unzip chromedriver.zip chromedriver -d /usr/bin/ && \
    # install rar
    wget --no-check-certificate -q -O rarlinux.tar.gz http://www.rarlab.com/rar/rarlinux-x64-6.0.0.tar.gz && \
    tar -xzvf rarlinux.tar.gz && \
    cd rar && \
    cp -v rar unrar /usr/bin/ && \
    # clean up
    rm -rf /tmpk

RUN wget -q https://raw.githubusercontent.com/SlamDevs/slam-mirrorbot/master/requirements.txt \
    && pip3 install -I -r requirements.txt \
    && pip3 install virtualenv \
    && rm requirements.txt
