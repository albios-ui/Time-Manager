#!/bin/sh
# Docker entrypoint script.

# Sets up tables and running migrations.
./bin/app eval "App.Release.migrate"