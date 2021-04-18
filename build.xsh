#!/usr/bin/env xonsh

$RAISE_SUBPROC_ERROR = True

import sys
from os.path import dirname,abspath,exists,join
$DIR = DIR = dirname(abspath(__file__))
sys.path.insert(0, DIR)
cd $DIR
trace on

from platform_simple import platform
from shutil import which
from json import load,dump

MAIN = join(DIR, "main")


with open(join(MAIN,"package.json")) as f:
  NAME = load(f)['productName']

def build(ico):
  if not exists(join(MAIN, "node_modules")):
    cd @(MAIN)
    yarn
  npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/
  npx --yes electron-packager ./main --overwrite --icon=$DIR/app.@(ico) --prune=true --out=$DIR/app --asar

def darwin():
  build("icns")
  cd $DIR/app
  arch = "x64"

  config = {
    "title": NAME,
    "format": "UDBZ",
    "icon": f"{DIR}/app.icns",
    "contents": [{
      "x": 448,
      "y": 344,
      "type": "link",
      "path": "/Applications"
    },
    {
      "x": 192,
      "y": 344,
      "type": "file",
      "path": f"./{NAME}-darwin-{arch}/{NAME}.app"
    }
    ],
    "window": {
      "size": {
        "width": 640,
        "height": 480
      }
    }
  }
  fp = join(DIR,"app","mac.json")
  with open(fp,"w") as out:
    dump(config, out)
  dmg = NAME+".dmg"
  rm -rf @(dmg)
  npx --yes appdmg @(fp) @(dmg)

print(platform)
locals()[platform]()
