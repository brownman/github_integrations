Travis + Github: 
----
**how to auto-deploy our website on every code change ?**
- Assume we have a github repository
- Assume we have a git branch: gh-pages

Sharing Travis-CI generated files (http://sleepycoders.blogspot.co.il/2013/03/sharing-travis-ci-generated-files.html)


steps:
---

 find out our github private key
```bash
get_private_key.sh
```

**update .travis.yml**

 update yaml key: **env.global.secure**
```bash
encrypt_private_key_for_use_in_travis.sh
```

