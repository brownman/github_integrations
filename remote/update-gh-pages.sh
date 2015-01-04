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

git_clone1(){
    commander git clone --depth=1 --quiet --branch=$branch https://${GH_TOKEN}@github.com/$owner/$repo.git $dir_gh_pages #> /dev/null 
}

 

rm2(){
  commander git rm -rf *
}

git_add_dir_product(){
  #commander rm2
  local dir_new
  dir_new="build/$TRAVIS_BUILD_NUMBER"
  mkdir -p $dir_new
  ### summary
  echo '```base' > README.md
  env | grep -v GH_TOKEN | grep -v password >> $dir_product/README.md
  echo '```' >> README.md
  ls -lR --sort=size $dir_product > $dir_product/log.txt  #_${TRAVIS_BUILD_NUMBER}.txt
  mv $dir_product/* $dir_new
}

git_add_commit_push(){
  git rm -rf *
  git_add_dir_product
  git add -f .  
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to $branch"
  git push -fq origin $branch 
}

git_checkout1(){
  commander git checkout -B $branch
}

 
 
git_fix_remote(){
cat .git/config | grep 'git://'
local old_string='git://'
local new_string='https://'
local file1=".git/config"
sed -i s@$old_string@$new_string@g $file1
cat $file1
}

steps(){
#commander cd $HOME

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  commander echo "PWD: $PWD"
  #commander debug_git
  commander setup_git_global
  commander setup_git_local
  commander git_fix_remote
  commander git_checkout1
  commander git_add_commit_push
  #commander git_stuff
 # commander override1
#  commander push1
fi
}

steps
