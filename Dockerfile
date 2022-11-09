FROM ubuntu:22.04
LABEL maintainer="janwiebe@janwiebe.eu"
RUN apt-get update -y
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
         nginx-full \
	 libnginx-mod-http-geoip \
	 php7.2-fpm \
         php7.2-bcmath \
         php7.2-gd \
         php7.2-json \
         php7.2-sqlite \
         php7.2-mysql \
         php7.2-curl \
         php7.2-xml \
         php7.2-mbstring \
         php7.2-zip \
	 php7.2-redis \
	 php7.2-int \
	 php7.2-geoip \
	 php7.2-igbinary \
	 php7.2-memcache \
	 php7.2-soap \
	 php7.2-msgpack \
	 php7.2-memcached \
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
COPY config/nginx/geoip/* /etc/nginx/geoip/
COPY config/nginx/conf.d/* /etc/nginx/conf.d/
COPY config/php/* /etc/php/
COPY config/php/7.2/cli/* /etc/php/7.2/cli/
COPY config/php/7.2/cli/conf.d/* /etc/php/7.2/cli/conf.d/
COPY config/php/7.2/fpm/* /etc/php/7.2/fpm/
COPY config/php/7.2/fpm/conf.d/* /etc/php/7.2/fpm/conf.d/
COPY config/php/7.2/fpm/pool.d/* /etc/php/7.2/fpm/pool.d/
COPY config/php/7.2/mods-available/* /etc/php/7.2/mods-available/
RUN rm -fr /etc/php/7.2/fpm/pool.d/www.conf
RUN groupadd -r -g 2001 ticketshop
RUN useradd -r -u 2001 -g 2001 -ms /bin/bash ticketshop
RUN mkdir -p /home/ticketshop
#USER 2001
WORKDIR /home/ticketshop
EXPOSE 80/tcp 443/tcp 22/tcp
STOPSIGNAL SIGQUIT
# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
