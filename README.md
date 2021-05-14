```
$ brew install hugo
$ git clone git@github.com:wikibootup/wikibootup.github.io.git public (If submodule not working properly)


# git submodule add -f -b master https://github.com/wikibootup/wikibootup.github.io.git public
# git submodule add --force https://github.com/tummychow/lanyon-hugo themes/lanyon-hugo


.git/modules/public/config
[submodule "public"]
	url = git@github.com:wikibootup/wikibootup.github.io.git
	fetch = +refs/heads/*:refs/remotes/origin/*
	active = true
```
