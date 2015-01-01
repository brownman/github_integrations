#!/usr/bin/env bash
set -u

#Goal:
#here we use our login name and password to find out our github private_key
#the private_key will use us as authorization token (OAuth) which we can pass to third-party clients for accessing our resource withouth the need to expose our credentials.

get_private_key(){
#http://sleepycoders.blogspot.co.il/2013/03/sharing-travis-ci-generated-files.html
#use github api to post our credentials and get our private key
your_github_username="$1"
your_github_password="$2"
echo -e "${your_github_password}\n" | curl -X POST -u $your_github_username -H "Content-Type: application/json" -d "{\"scopes\":[\"public_repo\"],\"note\":\"token for pushing from travis\"}" https://api.github.com/authorizations
}

echo please supply your github credentials: user and password
echo enter user
read user
echo enter password
read password
what_is_my_private_key "$user" "$password"
