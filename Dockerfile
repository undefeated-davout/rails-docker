FROM centos:7

ENV RUBY_VERSION 2.7.0
ENV RAILS_VERSION 6.0.2.1

# yum install
RUN yum update -y \
 && yum groupinstall -y "Development tools" \
 && yum -y install \
            autoconf \
            bzip2 \
            cmake \
            curl \
            epel-release \
            gcc \
            gcc-c++ \
            glibc-headers \
            libyaml-devel \
            make \
            openssl-devel \
            readline \
            readline-devel \
            sqlite-devel \
            sudo \
            unzip \
            vim \
            wget \
            zlib \
            zlib-devel \
 && rm -rf /var/cache/yum/* \
 && yum clean all

# git install
RUN yum remove -y git \
 && yum install -y https://centos7.iuscommunity.org/ius-release.rpm \
 && yum install -y \
            libsecret \
            pcre2 \
 && yum install -y git --enablerepo=ius --disablerepo=base,epel,extras,updates \
 && rm -rf /var/cache/yum/* \
 && yum clean all

# Japanese Locale Setting
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# alias
RUN echo "alias ll='ls -la -F'" >> ~/.bashrc

# Ruby install
ENV HOME /root
ENV RBENV_ROOT $HOME/.rbenv
ENV PATH $RBENV_ROOT/bin:$PATH
RUN git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv && \
    git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    eval "$(rbenv init -)"
RUN rbenv install ${RUBY_VERSION} && \
    rbenv global ${RUBY_VERSION}

# Ruby on Rails install
RUN echo 'install: --no-ri --no-rdoc' >> ~/.gemrc && \
    echo 'update: --no-ri --no-rdoc' >> ~/.gemrc
RUN source ~/.bashrc && \
    gem update --system && \
    gem install rails --version="${RAILS_VERSION}" && \
    gem install bundler
RUN rbenv rehash

# Node.js install
RUN curl -sL https://rpm.nodesource.com/setup_8.x | sudo bash - \
 && yum install -y nodejs \
 && npm install -g yarn \
 && rm -rf /var/cache/yum/* \
 && yum clean all

# SQLite install
RUN wget https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz \
 && tar xzvf sqlite-autoconf-3290000.tar.gz \
 && rm -f sqlite-autoconf-3290000.tar.gz \
 && cd sqlite-autoconf-3290000 \
 && ./configure --prefix=/opt/sqlite/sqlite3 \
 && make \
 && make install

# work directory
WORKDIR /code
