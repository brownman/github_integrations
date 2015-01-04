#!/usr/bin/env bash

branch='gh-pages'

create_branch_for_gh_pages(){
  git checkout -B $branch
  touch README.md
  echo test >> README.md
  git add -f README.md
  git commit -m "first commit"
  git push -fq origin $branch 
  git branch -r | grep $branch
  }

create_branch_for_gh_pages
