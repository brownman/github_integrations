#!/usr/bin/env bash


#shopt -s expand_aliases
set -u
alias commander=eval
dir_product=${dir_product:-/tmp/product}
test -d $dir_product || { mkdir -p $dir_product; }
branch='gh-pages'
dir_gh_pages=/tmp/gh_pages

debug1(){
  test -f .git/config && { cat .git/config; } 
  env
}

gitbook(){
  commander npm install gitbook -g
  local fmt='Static Website'
  local dir_readme="$dir_product"
  commander "gitbook build $dir_readme --format='$fmt'--output=$dir_product/gitbook"
}

setup_git(){
  #cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"
}

clone1(){
  local res=0
  echo "Starting to update $branch"
  echo
  #git checkout -B gh_pages
  $( git branch -r | grep $branch )
  res=$?
  commander cd dir_gh_pages
  
  if [ $res -eq 0 ];then
    git clone --depth=1 --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/$owner/$repo.git . > /dev/null 
  else
    git checkout -B $branch
    git add -f .  
  fi
}

rm2(){
  git rm -rf *
}

override1(){
  #commander rm2
  local dir_new=$dir_gh_pages/build/$TRAVIS_BUILD_NUMBER
  mkdir -p $dir_new

  ### summary
  ls -lR --sort=size $dir_product > $dir_new/log.txt  #_${TRAVIS_BUILD_NUMBER}.txt
  mv $dir_product $dir_new/
}

push1(){
  git add -f .  
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
  git push -fq origin $branch #> /dev/null
}

 


steps(){
git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  debug1
  setup_git
  clone1
  
  override1
  push1
  test1
fi
}

steps
