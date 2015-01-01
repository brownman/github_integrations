set -u

#Goal:
#travis will use this script to upload 

#CONFIG
user=${1:-$user}
repository=${2:-$repository}
dir_product="/tmp/product"
dir_to_refresh=gh-pages
flag_rm_old=true

test -d $dir_product || { mkdir -p $dir_product; }
echo 'example' >> $dir_product/example.txt


update-gh-pages(){
if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  echo -e "Starting to update gh-pages\n"

  #copy data we're interested in to other place
#  cp -R coverage $HOME/coverage

  #go to home and setup git
  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"

  #using token clone gh-pages branch
  git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/$user/$repository.git  $dir_to_refresh > /dev/null

  #go into diractory and copy data we're interested in to that directory
  cd $dir_to_refresh
  if [ $flag_rm_old -eq 0 ];then
    rm -rf *.*
  fi
  
  cp -Rf $dir_product/* .

  #add, commit and push files
  git add -f .
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
  git push -fq origin gh-pages > /dev/null

  echo -e "Done magic with coverage\n"
fi
}

update-gh-pages
