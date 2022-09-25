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

# Install NVM

# Installs python 3 and python 2
# RUN apt -y install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
# RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
# RUN tar -xf Python-3.10.*.tgz
# RUN cd Python-3.10.0 && ./configure --enable-optimizations && make -j 8 && make altinstall
# RUN rm -rf Python-3.10.0
# RUN rm Python-3.10.0.tgz
# RUN apt -y install python python3-pip
# RUN pip3 install --upgrade pip

# Install NVM
RUN git clone http://github.com/creationix/nvm.git /home/container/.nvm
RUN chmod -R 777 /home/container/.nvm
RUN bash /home/container/.nvm/install.sh
RUN bash -i -c 'nvm ls-remote'

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]