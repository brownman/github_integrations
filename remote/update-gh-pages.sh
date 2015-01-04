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

debug_git(){
  local dir=${1:-$PWD}
  test -f $dir/.git/config && { cat $dir/.git/config; } 
  git branch -r
 # env
}

setup_git_global(){
  #cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"
}
setup_git_local(){
  #debug_git
   git config credential.helper "store --file=.git/credentials"
  echo "https://${GH_TOKEN}:@github.com" > .git/credentials
  #debug_git
}
git_create_branch(){
  #http://www.zorched.net/2008/04/14/start-a-new-branch-on-your-remote-git-repository/
local  branch_name = $1
git push origin origin:refs/heads/${branch_name}
git fetch origin
git checkout --track -b ${branch_name} origin/${branch_name}
git pull
}
git_override(){
  git checkout -B $branch
  touch README.md
  echo test >> README.md
  git add -f README.md
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to $branch"
  git push -fq origin $branch #> /dev/null
  }
  
git_detect_remote(){
  ( commander "git branch -r | grep $branch" )
  res=$?
  echo we have remote branch named $branch ? $res
  
  if [ $res -eq 1 ];then
    echo
  fi
}
git_clone1(){
    commander git clone --depth=1 --quiet --branch=$branch https://${GH_TOKEN}@github.com/$owner/$repo.git $dir_gh_pages #> /dev/null 
}
git_stuff(){
  local res=0
  echo "Starting to update $branch"
  commander git_override
  #commander git_create_branch $branch
  #setup_git_local
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
  commander cd $dir_gh_pages
  commander ls -lt
  git add -f .  
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to $branch"
  git push -fq origin $branch #> /dev/null
}

 


steps(){
#commander cd $HOME

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  commander echo "PWD: $PWD"
  commander debug_git
  commander setup_git_global
  commander setup_git_local
  git branch -r
  #commander git_stuff
 # commander override1
#  commander push1
fi
}

steps
