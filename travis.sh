#!/usr/bin/env bash

dir_self=$( cd `dirname $0`; pwd )
chmod u+x *.sh . -R


source $dir_self/config.cfg
source $dir_self/override.cfg

 
$dir_self/ensure.sh && { bash -c $dir_self/BANK/travis_and_github/update-gh-pages.sh; } || {
  echo 'YOU NEED TO UPDATE .travis.yml;';
  echo 'HELP YOURSELF BY VISITING:';
  echo 'https://github.com/brownman/github_integrations';
}
