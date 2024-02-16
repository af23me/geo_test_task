FROM ruby:3.1.3-alpine3.17 as base

WORKDIR /usr/src/app

RUN apk add --no-cache gcompat tzdata postgresql-libs make g++ linux-headers postgresql-dev

COPY Gemfile* ./

RUN bundle install

COPY . .

CMD ["bin/bundle", "exec", "puma", "--log-requests"]