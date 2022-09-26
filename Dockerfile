FROM debian:bullseye

LABEL maintainer="DarkerInk <darkerinker@gmail.com>"

# Some Main Packages
RUN apt update && \
    apt upgrade -y && \
    apt install -y  software-properties-common locales


RUN apt install -y \
    zip \
    unzip \
    wget \
    curl \
    git \
    libtool \
    libtool-bin \ 
    ca-certificates

# Installs python 3 and python 2
RUN apt -y install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
RUN tar -xf Python-3.10.*.tgz
RUN cd Python-3.10.0 && ./configure --enable-optimizations && make -j 8 && make altinstall
RUN rm -rf Python-3.10.0
RUN rm Python-3.10.0.tgz
RUN apt -y install python python3-pip
RUN pip3 install --upgrade pip

ENV NVM_DIR /home/container/.nvm
ENV NODE_VERSION 16.17.0

# Install NVM
RUN git clone http://github.com/creationix/nvm.git "$NVM_DIR"
RUN chmod -R 777 "$NVM_DIR"
RUN bash "$NVM_DIR/install.sh"
RUN bash -i -c 'nvm ls-remote'


RUN echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> /home/container/.bashrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/container/.bashrc

# Install NodeJS (Via NVM)
RUN bash -i -c 'nvm install $NODE_VERSION'
RUN bash -i -c 'nvm use $NODE_VERSION'
RUN bash -i -c 'nvm alias default $NODE_VERSION'
RUN bash -i -c 'nvm use default'
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Install Yarn and PM2
RUN bash -i -c 'npm install -g yarn pm2'

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]