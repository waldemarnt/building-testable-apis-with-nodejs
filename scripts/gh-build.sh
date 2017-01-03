#!/bin/bash
set -o errexit

# config
git config --global user.email "ci@travis.com"
git config --global user.name "Travis CI"

# build
npm run build

# deploy
git add .
git commit -m "Build revision"
git push --force "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git" master
