FROM lazyatom/ruby-2.0

RUN apt-get install -y python

RUN mkdir /interblah.net
WORKDIR /interblah.net
ADD Gemfile /interblah.net/Gemfile
ADD Gemfile.lock /interblah.net/Gemfile.lock
RUN bundle install

ADD . /interblah.net
#RUN bundle install

ENTRYPOINT ["bundle", "exec"]
CMD ["rackup", "-p", "3000"]
