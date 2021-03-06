FROM circleci/elixir:latest-node-browsers

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

EXPOSE 4000

RUN mix local.hex --force
CMD mix deps.get && mix phx.server
