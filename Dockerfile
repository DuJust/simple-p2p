FROM daocloud.io/dujust/base-image:v0.0.5
MAINTAINER Du Just <du.just.it@gmail.com>

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --jobs 3

ADD . /app
RUN /app/docs_build.sh
VOLUME /app/public

EXPOSE 80

CMD ["/app/run"]
