Update template
* all set methods should return self

Bash
* move slepp instruction to dev function (I didn't see it when I execute that script on prod)
* test it on Windows Ubuntu (update readme.md)
* log and send message to slack

Bugs:
* doesn't send all code after change to repo (maybe it near something change after composer commands) that commands help` git add . && git commit -m "init commit" && git push`
* doesn't change link for alpha module branch ( `sed -i "s/MODULE_REPO/$moduleName/" ./README.md` )