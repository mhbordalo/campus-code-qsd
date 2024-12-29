FROM ruby:3.2.0

RUN apt-get update -qq && apt-get install -y nodejs

WORKDIR /app

COPY Gemfile /app/Gemfile

COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . .

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]