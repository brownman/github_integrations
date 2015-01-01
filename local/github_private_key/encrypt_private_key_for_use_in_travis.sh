#!/usr/env/bin bash

echo type your github user
read user
echo type your github repository
read repository
echo type your github private_key
read private_key

encrypt_private_key_for_use_in_travis(){
gem install travis
sudo apt-get install xsel

#auto? for auto-update the .travis file, one can Add: '--add env.global'
travis encrypt -r ${user}/${repository} GH_TOKEN=${private_key} | xsel --clipboard
res=$?
if [ $res -eq 0 ];then
echo clipboard updated !
echo "update your repo: $user/$repository/.travis.yml"
cat <<START
env:
  global:
    GH_TOKEN: your-encrypted-token
START
fi

}

encrypt_private_key_for_use_in_travis
