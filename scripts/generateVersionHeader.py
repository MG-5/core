#!/bin/python3
import sys
import datetime
import git  # pip3 install gitpython

if len(sys.argv) != 3:
    raise "not enough parameters"

repoPath = sys.argv[1]
versionHeaderPath = sys.argv[2]

repo = git.Repo(repoPath, search_parent_directories=True)

if len(repo.submodules) == 0:
    print("Tested git repository has no submodules, path is not pointing to the main repository")
    exit(1)

commitHashLong = str(repo.head.object.hexsha)
commitHashShort = commitHashLong[:8]
isDirty = repo.is_dirty()
branch = repo.active_branch.name
currentTime = str(datetime.datetime.now().isoformat())


fileContent = '#define BUILD_INFO_COMMIT_SHORT "' + commitHashShort + '"\n'
if isDirty:
    fileContent += '#define BUILD_INFO_IS_DIRTY true\n'
else:
    fileContent += '#define BUILD_INFO_IS_DIRTY false\n'
fileContent += '#define BUILD_INFO_TIME "' + currentTime + '"\n'
fileContent += '#define BUILD_INFO_COMMIT_LONG "' + commitHashLong + '"\n'
fileContent += '#define BUILD_INFO_BRANCH "' + branch + '"\n'

# read back file and compare, don't overwrite if nothing changes
# due to time being included, something always changes but in case
# this goes away, we can save some compile runs
doRegen = True
try:
    with open(versionHeaderPath, mode='r') as oldFile:
        content = oldFile.read()
        if content == fileContent:
            print("No change detected")
            doRegen = False
        else:
            print("Version info changed")
except:
    print("Old file not found")

if doRegen:
    with open(versionHeaderPath, mode='w') as newFile:
        newFile.write(fileContent)
        print("Regenerated")
        exit(0)