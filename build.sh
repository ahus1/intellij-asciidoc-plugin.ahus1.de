#!/usr/bin/env bash
set -ex

yarn generate

# serve site on localhost and run link checker
# this call is optimized to run on the netlify server
node /opt/build/repo/node_modules/.bin/http-server dist -p 5000 -a 127.0.0.1 &
child_id=$!

cd blc
yarn install
yarn blc
cd ..

cd pa11y
yarn install
yarn check-dist
cd ..

ps xu
kill $child_id || true
ps xu

cd lambda
yarn install
yarn generate
cd ..
