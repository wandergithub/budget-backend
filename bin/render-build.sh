#!/usr/bin/env bash
# exit on error
set -o errexit
bundle exec rails --version

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# Seed the database
bundle exec rails db:seed