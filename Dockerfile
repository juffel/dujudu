FROM seleniarm/standalone-chromium:latest

RUN sudo apt-get update
RUN sudo apt-get -y install gcc make inotify-tools

WORKDIR /tmp
RUN sudo apt-get update
RUN sudo apt-get -y install erlang=1:24.3.4.1+dfsg-1
RUN sudo apt-get -y install elixir=1.12.2.dfsg-2.2

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

EXPOSE 4000

RUN mix local.hex --force
RUN mix local.rebar --force

CMD mix deps.get && mix phx.server
