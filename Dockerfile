FROM ruby:3.1.2
LABEL image-description="Docker Rails Mongo Application"

RUN apt-get dist-upgrade && apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn git tzdata

WORKDIR /rails-mongo-dockerized
COPY . /rails-mongo-dockerized/

RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]