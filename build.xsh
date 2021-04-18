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
  cd @(MAIN)
  if not exists(join(MAIN, "node_modules")):
    yarn
  npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/
  npx --yes electron-packager . --overwrite --icon=$DIR/app.@(ico) --prune=true --out=$DIR/app --asar
  cd $DIR/app

def darwin():
  build("icns")
  arch = "x64"

  config = {
    "title": NAME,
    "format": "ULFO",
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

def win():
  build("ico")
  mv @(f"{NAME}-win32-x64/*") @(NAME)
  7z a -ms=on -m0=lzma -mx=9 -mfb=273 @(NAME).7z @(NAME)


print(platform)
locals()[platform]()
