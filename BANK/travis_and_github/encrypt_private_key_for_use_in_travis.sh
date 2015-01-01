#!/usr/bin/env bash
set -u

#Notice:
#travis environment will store your passwords
#--> BAD practice:
#echo $GH_TOKEN
#echo $gmail_password
#---> GOOD practice:
#echo $GH_TOKEN &>/dev/null
test $# -eq 3 || { echo supply info: user , repo , private_key; exit 0; }
user=$1
repository=$2
private_key=$2

some_other_passwords='gmail_password=blabla twitter_password=blablabla'

encrypt_private_key_for_use_in_travis(){

#auto? for auto-update the .travis file, one can Add: '--add env.global'
travis encrypt -r ${user}/${repository} "$some_other_passwords GH_TOKEN=${private_key}" | xsel --clipboard
res=$?
if [ $res -eq 0 ];then
echo 'clipboard updated !'
echo "update your repo: $user/$repository/.travis.yml"
fi
}

encrypt_private_key_for_use_in_travis
