#!/usr/bin/env bash

dir_self=$( cd `dirname $0`; pwd )
chmod u+x *.sh . -R

bash -c $dir_self/install.sh
source $dir_self/config.cfg
source $dir_self/override.cfg

 
$dir_self/ensure.sh || { 
 toilet --metal "OOPS"
  echo 'YOU NEED TO UPDATE .travis.yml;';
  echo 'HELP YOURSELF BY VISITING:';
  echo 'https://github.com/brownman/github_integrations';
  exit 1;
}

bash -c $dir_self/travis/update-gh-pages.sh; 
