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

 
