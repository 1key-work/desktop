#!/usr/bin/env xonsh

$RAISE_SUBPROC_ERROR = True

import sys
from os.path import dirname,abspath,exists,join
$DIR = DIR = dirname(abspath(__file__))
sys.path.insert(0, DIR)
cd @(DIR)
trace on

import traceback
from shutil import which
from json import load

def main(ext_li, platform=None):
  github_release = "github-release"

  if not which(github_release):
    go get github.com/github-release/@(github_release)
  
  with open("main/package.json",,encoding="utf-8") as f:
    o = load(f)

  email = o['email']
  productName = o['productName']
  package_name = o['name']
  git config user.name @(o['author'])
  git config user.email @(email)

  version = o['version']
  print(version)

  with open(".git/config") as f:
    for line in f:
      line = line.strip()
      if line.startsWith("url = "):
         repository = line.split("=",1).pop().lstrip()
         break
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
    name = f"{package_name}.{version}.{platform}.{ext}"
    print(f"upload {name}")
    r = !(github-release upload --user @(user) --repo @(repo) --tag @(tag) --name @(name) --file app/app.@(ext))
    if r.rtn:
      print(r.errors)
  $RAISE_SUBPROC_ERROR = True

from platform_simple import platform

PLATFORM = dict(
  darwin=["dmg", "mac"],
  win=["exe,7z","win64"],
)
main(*PLATFORM[platform])
