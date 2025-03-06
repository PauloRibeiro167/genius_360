FROM ruby:3.2.2
RUN gem update --system && gem install bundler -v '~> 2.4.0'

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
