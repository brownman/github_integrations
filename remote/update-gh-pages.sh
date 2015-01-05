#!/usr/bin/env bash
set -u
#exec 2>/tmp/err

#config
branch='gh-pages'
( test -v dir_product && test -d $dir_product )  || { echo 1>&2 update .travis.yml with the directory u want to upload to github pages; exit 1; }


#ensure
test -v owner
test -v repo
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
   echo github_integrations >> .gitignore
   #http://stackoverflow.com/questions/20192070/how-to-move-all-files-including-hidden-files-into-parent-directory-via
   shopt -s dotglob
   commander cp -rf $dir_product/* .
   shopt -u dotglob
  fi
  
  #commander mv -rf $dir_product/* .
  commander git add .
  
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
  commander tree $dir_product
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
