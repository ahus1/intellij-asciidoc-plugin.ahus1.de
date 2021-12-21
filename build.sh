#!/usr/bin/env bash
set -e
set -x

# prepare start page with jekyll
jekyll build --source startpage --destination _site

# install already performed by Netlify before this script runs
# yarn install

# prepare antora: enable document search; override URL environment variable as Antora "looks" at it
export URL=${URL}/docs && \
yarn build

# configure netlify
cat _redirects_top >> _site/_redirects
cat _site/docs/_redirects >> _site/_redirects
cat _redirects_end >> _site/_redirects

# debugging
cat _site/_redirects

# preparing lambda
cd lambda
yarn install
yarn generate
cd ..

# search engines should only index the main branch
if [ "$BRANCH" != "main" ]; then
cat >> _site/_headers << EOF
/*
  x-robots-tag: noindex
EOF
fi
