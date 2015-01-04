#!/usr/bin/env bash
set -u
#exec 2>/tmp/err

#config
branch='gh-pages'
dir_product=${dir_product:-/tmp/product}
dir_gh_pages=/tmp/gh_pages

#ensure
test -v owner
test -v repo
test -d $dir_product || { mkdir -p $dir_product; }
test -d $dir_gh_pages || { mkdir -p $dir_gh_pages; }


################################################# git debug
debug_git(){
  local dir=${1:-$PWD}
  test -f $dir/.git/config && { cat $dir/.git/config; } 
  git branch -r
 # env
}
################################################# git config
setup_git_global(){
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"
}
setup_git_local(){
  git config credential.helper "store --file=.git/credentials"
  echo "https://${GH_TOKEN}:@github.com" > .git/credentials
}
################################################# the product
git_mv_dir_product(){
  #commander rm2
  local dir_new
  dir_new="build/$TRAVIS_BUILD_NUMBER"
  mkdir -p $dir_new
  ### summary
   env | grep -v GH_TOKEN | grep -v password > $dir_product/env.txt
   ls -lR --sort=size $dir_product > $dir_product/log.txt  #_${TRAVIS_BUILD_NUMBER}.txt
   mv $dir_product $dir_new
}
git_add_commit_push(){
  if [ "$repo" = 'github_integrations' ];then
    commander git rm -rf *
    commander git_mv_dir_product
  else
    commander git add -f .  
  fi
  commander "git commit -m \"Travis build $TRAVIS_BUILD_NUMBER pushed to $branch\""
  commander git push -fq origin $branch 
}
git_fix_remote(){
cat .git/config | grep 'git://'
local old_string='git://'
local new_string='https://'
local file1=".git/config"
sed -i s@$old_string@$new_string@g $file1
cat $file1
}
########################################### steps
steps(){
#commander cd $HOME

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  commander echo "PWD: $PWD"
  #commander debug_git
  commander setup_git_global
  commander setup_git_local
  commander git_fix_remote
  commander git checkout -B $branch
    git_add_commit_push

  #commander git_stuff
 # commander override1
#  commander push1
fi
}

steps
