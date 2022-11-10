FROM ubuntu:22.04
LABEL maintainer="janwiebe@janwiebe.eu"
RUN apt-get update -y
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
         nginx-full \
	 php7.4-fpm \
         php7.4-bcmath \
         php7.4-gd \
         php7.4-json \
         php7.4-sqlite \
         php7.4-mysql \
         php7.4-curl \
         php7.4-xml \
         php7.4-mbstring \
         php7.4-zip \
	 php7.4-redis \
	 php7.4-int \
	 php7.4-geoip \
	 php7.4-igbinary \
	 php7.4-memcache \
	 php7.4-soap \
	 php7.4-msgpack \
	 php7.4-memcached \
         mcrypt \
         nano \
	 supervisor \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	;
COPY config/nginx/* /etc/nginx/
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nginx/snippets/* /etc/nginx/snippets/
COPY config/nginx/modules-enabled/* /etc/nginx/modules-enabled/
COPY config/nginx/conf.d/* /etc/nginx/conf.d/
COPY config/php/* /etc/php/
COPY config/php/7.2/cli/* /etc/php/7.4/cli/
COPY config/php/7.2/cli/conf.d/* /etc/php/7.4/cli/conf.d/
COPY config/php/7.2/fpm/* /etc/php/7.4/fpm/
COPY config/php/7.2/fpm/conf.d/* /etc/php/7.4/fpm/conf.d/
COPY config/php/7.2/fpm/pool.d/* /etc/php/7.4/fpm/pool.d/
COPY config/php/7.2/mods-available/* /etc/php/7.4/mods-available/
RUN rm -fr /etc/php/7.4/fpm/pool.d/www.conf
RUN groupadd -r -g 2001 ticketshop
RUN useradd -r -u 2001 -g 2001 -ms /bin/bash ticketshop
RUN mkdir -p /home/ticketshop
#USER 2001
WORKDIR /home/ticketshop
EXPOSE 80/tcp 443/tcp 22/tcp
STOPSIGNAL SIGQUIT
# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
