#!/usr/bin/env bash
set -e
set -x

# prepare start page with jekyll
jekyll build --source startpage --destination _site

# prepare antora: enable document search; override URL environment variable as Antora "looks" at it
export DOCSEARCH_ENABLED=true && export DOCSEARCH_ENGINE=lunr && \
export URL=${URL}/docs && \
yarn install && \
echo "monkey-patch antora-lunr for https://github.com/Mogztter/antora-lunr/pull/56 / will be part of v0.7.2+ " && \
cp _antora/generate-index.js node_modules/antora-lunr/lib && \
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

# search engines should only index the master branch
if [ "$BRANCH" != "master" ]; then
cat >> _site/_headers << EOF
/*
  x-robots-tag: noindex
EOF
fi
