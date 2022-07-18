FROM php:7.2-apache
RUN apt-get update && apt-get upgrade -y

# PHP Extension 의존성 추가: pdo, pdo-mysql
RUN docker-php-ext-install pdo pdo_mysql

# PECL 의존성 추가: redis
RUN pecl install redis \
&& docker-php-ext-enable redis

# Apache rewrite 모듈 활성화
RUN a2enmod rewrite
# Apache 설정 파일 주입
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir /tmp/session && mkdir /tmp/wsdlcache && chmod 777 /tmp/session && chmod 777 /tmp/wsdlcache

RUN echo session.save_handler = "files" >> /usr/local/etc/php/php.ini && echo session.save_path = "/tmp/session" >> /usr/local/etc/php/php.ini && echo soap.wsdl_cache_dir = "/tmp/wsdlcache" >> /usr/local/etc/php/php.ini && echo short_open_tag = On >> /usr/local/etc/php/php.ini && echo date.timezone = Asia/Seoul >> /usr/local/etc/php/php.ini \
	 && echo post_max_size = 100M >> /usr/local/etc/php/php.ini && echo max_input_vars = 100000 >> /usr/local/etc/php/php.ini

EXPOSE 80
