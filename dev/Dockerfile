# Elixir + Phoenix

FROM elixir:1.9.1-alpine

# Install debian packages
RUN apk update && apk add g++ make inotify-tools \
  git postgresql-client npm nodejs

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

WORKDIR /app
EXPOSE 4000
