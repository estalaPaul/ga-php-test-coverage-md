FROM php:7.1-cli

LABEL "com.github.actions.name"="GA-PHPTestCoverage"
LABEL "com.github.actions.description"="Run phpunit --coverage-html on PR"
LABEL "com.github.actions.icon"="aperture"
LABEL "com.github.actions.color"="blue"

LABEL version="0.0.1"
LABEL repository="https://github.com/estalaPaul/ga-php-test-coverage-md"
LABEL homepage="https://github.com/estalaPaul/ga-php-test-coverage-md"

RUN apt-get update && apt-get -y install zip unzip pandoc jq libicu-dev && docker-php-ext-configure intl && docker-php-ext-install intl && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer

RUN mkdir /phpunit && cd /phpunit && composer require phpunit/phpunit && ln -s /phpunit/vendor/bin/phpunit /usr/local/bin/phpunit

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
