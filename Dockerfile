FROM elixir:1.12.2-alpine AS build

# install build dependencies
RUN \
    apk add --no-cache \
    build-base \
    npm \
    git \
    python3 \
    make \
    cmake \
    openssl-dev \ 
    libsrtp-dev \
    ffmpeg-dev \
    clang-dev

ARG VERSION
ENV VERSION=${VERSION}

# Create build workdir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY assets assets
COPY priv priv
# the lib code must be there first so the tailwindcss can properly inspect the code
# to gather necessary classes to generate
COPY lib lib

RUN mix setup
RUN mix deps.compile

RUN mix assets.deploy

# compile and build release

RUN mix do compile, release

# prepare release image
FROM alpine:3.13 AS app

# install runtime dependencies
RUN \
    apk add --no-cache \
    openssl \
    ncurses-libs \
    libsrtp \
    ffmpeg \
    clang \ 
    curl

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/membrane_videoroom_demo ./

ENV HOME=/app

EXPOSE 4000

HEALTHCHECK CMD curl --fail http://localhost:4000 || exit 1  

CMD ["bin/membrane_videoroom_demo", "start"]
