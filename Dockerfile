FROM ruby:2.5.7

RUN gem install bundler -v 1.17.3
RUN gem install rails -v 5.2.4.1

WORKDIR /opt/app

COPY Gemfile* ./

RUN bundle install

# RUN apt-get update && apt-get install nano -y

CMD ["/bin/bash"]
