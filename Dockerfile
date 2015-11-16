FROM ruby:2.0.0

RUN apt-get update
RUN apt-get install -y python ruby2.1-dev

RUN mkdir /interblah.net
WORKDIR /interblah.net
ADD Gemfile /interblah.net/Gemfile
ADD Gemfile.lock /interblah.net/Gemfile.lock
RUN bundle install

ADD . /interblah.net
#RUN bundle install

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rackup", "-p", "3000"]
