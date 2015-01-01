#!/usr/bin/env bash


#shopt -s expand_aliases
set -u
alias commander=eval
dir_product=${dir_product:-/tmp/product}
test -d $dir_product || { mkdir -p $dir_product; }

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
clone1(){
    echo -e "Starting to update gh-pages\n"
  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"
  #git checkout -B gh_pages
  git clone --depth=1 --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/$owner/$repo.git  gh-pages > /dev/null 
}

rm2(){
#test -d old || { mkdir old; }
#mv *.* old/
git rm -rf *
}

migrate1(){
cd gh-pages
#commander rm2
dir_new=build/$TRAVIS_BUILD_NUMBER
mkdir -p $dir_new
#
##mv  $dir_product $dir_new/media #/* files
##mv /tmp/log $dir_new/log
### summary
ls -lR --sort=size $dir_new > $dir_new/log.txt  #_${TRAVIS_BUILD_NUMBER}.txt
mv $dir_product $dir_new/
}

push1(){
git add -f .  
git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
git push -fq origin gh-pages #> /dev/null
}

test1(){
local branch=test1
git checkout -B $branch

#change
touch 1.txt
echo test1 > 1.txt

#git add
git add -f .  

#git commit
git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
git push -fq origin $branch #> /dev/null  
}

steps(){

git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
debug1
  clone1
  
  migrate1
  push1
  test1
fi
}

steps
