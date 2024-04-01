FROM docker.io/php:8.2-apache-bookworm

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
	libmemcached-dev \
	libssl-dev \
	zlib1g-dev \
	libpng-dev \
	libldap-dev \
	unzip \
	&& rm -rf /var/lib/apt/lists/*

RUN pecl install memcached-3.2.0 && \
	/usr/local/bin/docker-php-ext-install \
	mysqli \
	gd \
	pdo_mysql \
	sockets \
	ldap \
	&& \
	/usr/local/bin/docker-php-ext-enable \
	memcached \
	mysqli \
	gd \
	pdo_mysql \
	sockets \
	ldap \
	&& \
	/usr/sbin/a2enmod rewrite && \
	/usr/sbin/a2dissite 000-default

COPY i-doit.ini /usr/local/etc/php/conf.d/
COPY i-doit.conf /etc/apache2/sites-available/i-doit.conf
RUN /usr/sbin/a2ensite i-doit

RUN mkdir -p /var/www/html/i-doit/ && \
	cd /var/www/html/i-doit/ && \
	curl -sLo /tmp/i-doit.zip \
	https://downloads.sourceforge.net/project/i-doit/i-doit/29/idoit-open-29.zip && \
	unzip /tmp/i-doit.zip && \
	chown www-data:www-data -R . && \
	find . -type d -name \* -exec chmod 775 {} \; && \
	find . -type f -exec chmod 664 {} \;

VOLUME /var/www/html/i-doit/
