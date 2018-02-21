#!/bin/sh
REPOSITORY_URL=$(git config --get remote.origin.url | sed  's/\.git//g');
REPOSITORY_COMMITSURL="${REPOSITORY_URL}/commit"

dateCommit=$(git log -1 --date=short --pretty=format:%cd)

latestRef=$(git log origin/master -1 --format="%H")
latestCmt=$(git log -1 --format="%H")

# write datas into changelog file...
# 1: get current changelog content
fileContent=$(<test.md);
# 2: Clear changelog file by addind Header
echo '# CHANGELOG
## '$dateCommit'
' > test.md;
# 2.a: add all [Fix] new commits
echo '
<b>Fix</b>
' >> test.md;
git log `git describe --all  --abbrev=0 HEAD^` --pretty=format:'- [%h]('$REPOSITORY_COMMITSURL'/%H) %s' ${latestRef}..${latestCmt}  --reverse --no-merges | grep "Fix: "  >> test.md
# 2.b: add all [Update] new commits
echo '
<b>Update</b>
' >> test.md;
git log `git describe --all  --abbrev=0 HEAD^` --pretty=format:'- [%h]('$REPOSITORY_COMMITSURL'/%H) %s' ${latestRef}..${latestCmt}  --reverse --no-merges | grep "Update: "  >> test.md
# 2.c: add all [Feature] new commits
echo '
<b>Feature</b>
' >> test.md;
git log `git describe --all  --abbrev=0 HEAD^` --pretty=format:'- [%h]('$REPOSITORY_COMMITSURL'/%H) %s' ${latestRef}..${latestCmt}  --reverse --no-merges | grep "Feature: "  >> test.md
# 2.d: add all [Core] new commits
echo '
<b>Core</b>
' >> test.md;
git log `git describe --all  --abbrev=0 HEAD^` --pretty=format:'- [%h]('$REPOSITORY_COMMITSURL'/%H) %s' ${latestRef}..${latestCmt}  --reverse --no-merges | grep "Core: "  >> test.md

echo "
"  >> test.md;
# 3: add saved previous changelog file content
echo "$fileContent" | sed -e '1d' >> test.md;
