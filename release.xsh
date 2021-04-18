#!/usr/bin/env xonsh

$RAISE_SUBPROC_ERROR = True

from os.path import dirname,abspath,exists
DIR = dirname(dirname(abspath(__file__)))
cd @(DIR)

import traceback
from shutil import which
from json import load

def main(platform, ext_li):
  github_release = "github-release"

  if not which(github_release):
    go get github.com/github-release/@(github_release)

  with open("package.json") as f:
    o = load(f)

  email = o['email']
  git config user.name @(o['author'])
  git config user.email @(email)

  version = o['version']
  print(version)
  repository = o['repository']
  _, user, repo = repository.rsplit("/",2)
  repo = repo.rsplit(".")[0]
  print(user,repo)

  with open(f"version/{version}.md", encoding="utf8") as f:
    desc = f.read()

  tag = f"v{version}"

  r = !(github-release release --user @(user) --repo @(repo) --tag @(tag) --name @(tag) --description @(desc))
  $RAISE_SUBPROC_ERROR = False
  if r.rtn:
    errors = r.errors
    if "422 Unprocessable Entity" not in errors and "already_exists" not in errors:
      raise Exception(errors)
  else:
    sleep 3
  for ext in ext_li.split(","):
    name = f"{platform}-{email.split('@',1).pop()}-{version}.{ext}"
    print(f"upload {name}")
    r = !(github-release upload --user @(user) --repo @(repo) --tag @(tag) --name @(name) --file dist/app.@(ext))
    if r.rtn:
      print(r.errors)
  $RAISE_SUBPROC_ERROR = True

main($ARG1, $ARG2)
