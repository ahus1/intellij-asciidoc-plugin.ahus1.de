#!/usr/bin/env bash
set -e
set -x

# prepare start page with jekyll
jekyll build --source startpage --destination _site

# configure netlify
cp _redirects _site/_redirects

# prepare antora
export DOCSEARCH_ENABLED=true && export DOCSEARCH_ENGINE=lunr && \
yarn install && \
echo "monkey-patch antora-lunr for https://github.com/Mogztter/antora-lunr/pull/56 / will be part of v0.7.2+ " \
cp _antora/generate-index.js node_modules/antora-lunr/lib && \
yarn build

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
