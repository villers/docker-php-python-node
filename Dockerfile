FROM php:7.1-cli

MAINTAINER Mickael VILLERS <mickael.villers@epitech.eu>

# Set correct environment variables.
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME /root

# Ubuntu mirrors
RUN apt-get update

# Repo for Yarn
RUN apt-key adv --fetch-keys http://dl.yarnpkg.com/debian/pubkey.gpg
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Repo for Node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Install requirements for standard builds.
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    apt-transport-https \
    ca-certificates \
    openssh-client \
    wget \
    bzip2 \
    git \
    build-essential \
    libmcrypt-dev \
    libicu-dev \
    libmcrypt-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng12-dev \
    python-yaml \
    python-jinja2 \
    python-httplib2 \
    python-keyczar \
    python-paramiko \
    python-setuptools \
    python-pkg-resources \
    python-pip \
    unzip \
    rsync \
    nodejs \
    yarn \

  # Standard cleanup
  && apt-get autoremove -y \
  && update-ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \

  # Install common PHP packages.
  && docker-php-ext-install \
      iconv \
      mcrypt \
      mbstring \
      bcmath \
      intl \

  # Configure and install PHP GD
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \

  # Composer installation.
  && curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/bin/composer \
  && composer selfupdate \

  # Add fingerprints for common sites.
  && mkdir ~/.ssh \
  && ssh-keyscan -H github.com >> ~/.ssh/known_hosts \
  && ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts

# Show versions
RUN php -v
RUN node -v
RUN npm -v
RUN python --version

CMD ["bash"]
