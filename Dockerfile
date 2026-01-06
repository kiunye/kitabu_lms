FROM elixir:1.18-alpine AS builder

ARG SECRET_KEY_BASE
ARG DATABASE_URL

ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
ENV DATABASE_URL=${DATABASE_URL}
ENV MIX_ENV=prod

WORKDIR /app

RUN apk add --no-cache build-base git

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod && \
    mix deps.compile

COPY priv priv
COPY lib lib
COPY assets assets

RUN mix assets.build && \
    mix phx.digest

RUN mix release

FROM alpine:3.21 AS app

ARG RELEASE_VERSION=0.1.0
ARG RUNNER_GROUP=nobody

ENV RELEASE_VERSION=${RELEASE_VERSION}
ENV MIX_ENV=prod

WORKDIR /app

RUN addgroup -g 1000 -S ${RUNNER_GROUP} && \
    adduser -S nobody -u 1000 -G ${RUNNER_GROUP}

RUN apk add --no-cache openssl libcrypto3 libpq curl

COPY --from=builder /app/_build/prod/rel/kitabu_lms ./

RUN chown -R nobody:nobody /app

USER nobody

ENV HOME=/home/nobody
ENV releases_path=/app/releases

ENTRYPOINT ["sh", "-c", "exec $releases_path/$RELEASE_VERSION/kitabu_lms start"]
