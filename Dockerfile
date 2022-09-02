FROM elixir:latest

RUN apt-get update
RUN apt-get -y install inotify-tools

# install chromedriver
RUN apt-get -y install chromium=104.0.5112.101-1~deb11u1
WORKDIR /tmp
RUN wget https://chromedriver.storage.googleapis.com/104.0.5112.79/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/
RUN chmod +x /usr/bin/chromedriver

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

EXPOSE 4000

RUN mix local.hex --force
RUN mix local.rebar --force

CMD mix deps.get && mix phx.server
