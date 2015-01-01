#!/usr/bin/env bash
set -u
exec 2>/tmp/err

#config
branch='gh-pages'
dir_product=${dir_product:-/tmp/product}
dir_gh_pages=/tmp/gh_pages


#ensure
test -v owner
test -v repo
test -d $dir_product || { mkdir -p $dir_product; }
test -d $dir_gh_pages || { mkdir -p $dir_gh_pages; }

debug1(){
  local dir=$1
  test -f $dir/.git/config && { cat $dir/.git/config; } 
 # env
}

setup_git_global(){
  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"
}
setup_git_local(){
   git config credential.helper "store --file=.git/credentials"
  echo "https://${GH_TOKEN}:@github.com" > .git/credentials
}

clone1(){
  local res=0
  echo "Starting to update $branch"
  echo
  #git checkout -B gh_pages
  $( git branch -r | grep $branch )
  res=$?
  commander cd $dir_gh_pages
  
  if [ $res -eq 0 ];then
    git clone --depth=1 --quiet --branch=$branch https://${GH_TOKEN}@github.com/$owner/$repo.git . > /dev/null 
  else
    git checkout -B $branch
  fi
  
  setup_git_local
}

rm2(){
  git rm -rf *
}

override1(){
  #commander rm2
  local dir_new
  dir_new="$dir_gh_pages/build/$TRAVIS_BUILD_NUMBER"
  mkdir -p $dir_new

  ### summary
  ls -lR --sort=size $dir_product > $dir_new/log.txt  #_${TRAVIS_BUILD_NUMBER}.txt
  mv $dir_product $dir_new/
}

push1(){
  git add -f .  
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to $branch"
  git push -fq origin $branch #> /dev/null
}

 


steps(){


if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  setup_git_global
  clone1
  
  override1
  push1
fi
}

steps
