#!/usr/bin/env bash

dir_self=$( cd `dirname $0`; pwd )
chmod u+x *.sh . -R

source $dir_self/cfg/config.cfg


bash -c $dir_self/sh/install.sh
source $dir_self/cfg/override.cfg
$dir_self/sh/ensure.sh || { 
toilet --metal "OOPS"
echo 'YOU NEED TO UPDATE .travis.yml;';
echo 'HELP YOURSELF BY VISITING:';
echo 'https://github.com/brownman/github_integrations';
exit 1;
}

( bash -e $dir_self/remote/update-gh-pages.sh )

