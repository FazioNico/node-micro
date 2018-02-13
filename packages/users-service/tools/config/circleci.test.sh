#!/usr/bin/env bash
set -e
yarn install --silent --non-interactive --no-lockfile
yarn run test
