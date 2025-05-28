# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# ✅ Install base packages (Ruby, Python3, Pip, SQLite, etc.)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips sqlite3 \
    python3 python3-pip libpq-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ✅ Set environment variables for production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# ---- BUILD STAGE ----
FROM base AS build

# ✅ Install build tools & MySQL dev libs
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git pkg-config \
    default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ✅ Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# ✅ Install Python dependencies
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# ✅ Copy all app code
COPY . .

# ✅ Precompile Rails app
RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE=DUMMY ./bin/rails assets:precompile

# ---- FINAL STAGE ----
FROM base

# ✅ Copy compiled app and gems from build stage
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# ✅ Create non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails

# ✅ Entrypoint & CMD
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
