#!/usr/bin/env bash
set -u
set +e
#Goal:
#here we use our login name and password to find out our github private_key
#the private_key will use us as authorization token (OAuth) which we can pass to third-party clients for accessing our resource withouth the need to expose our credentials.

get_private_key(){
#http://sleepycoders.blogspot.co.il/2013/03/sharing-travis-ci-generated-files.html
#use github api to post our credentials and get our private key
echo -e "$your_github_password" | xsel --clipboard 
echo clipboard updated 
echo paste the password
curl -X POST -u $your_github_username -H "Content-Type: application/json" -d "{\"scopes\":[\"public_repo\"],\"note\":\"token for pushing from travis\"}" https://api.github.com/authorizations
}

test $# -eq 2 || { echo please supply your github credentials: user and password; exit 0; }
your_github_username="$1"
your_github_password="$2"
get_private_key
