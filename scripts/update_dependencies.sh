#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# update pubspec.yaml
python3 scripts/update_pubspec.py

# Upgrade Flutter dependencies
flutter pub upgrade
