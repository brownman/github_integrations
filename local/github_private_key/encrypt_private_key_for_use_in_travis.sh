#!/usr/env/bin bash

#Notice:
#travis environment will store your passwords
#--> BAD practice:
#echo $GH_TOKEN
#echo $gmail_password
#---> GOOD practice:
#echo $GH_TOKEN &>/dev/null

echo type your github user
read user
echo type your github repository
read repository
echo type your github private_key
read private_key

some_other_passwords='gmail_password=blabla twitter_password=blablabla'

encrypt_private_key_for_use_in_travis(){
gem install travis
sudo apt-get install xsel

#auto? for auto-update the .travis file, one can Add: '--add env.global'
travis encrypt -r ${user}/${repository} "$some_other_passwords GH_TOKEN=${private_key}" | xsel --clipboard
res=$?
if [ $res -eq 0 ];then
echo 'clipboard updated !'
echo "update your repo: $user/$repository/.travis.yml"
echo 'it should be something like this:'

cat <<START
language: node_js 
cache: 
  - apt
  - npm

env:
  global:
    secure: '- the_travis_encrypt_output - '

before_install: 
  - chmod +x *.sh . -R  #fix permission of bash scripts
script:
  - grunt
  
after_success:
  -  ./github_private_key.sh
START

}

encrypt_private_key_for_use_in_travis
