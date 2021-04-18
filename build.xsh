#!/usr/bin/env xonsh

$RAISE_SUBPROC_ERROR = True

from shutil import which
from os.path import dirname,abspath,exists,join
from json import load,dump

trace on

$DIR = DIR = dirname(abspath(__file__))
MAIN = join(DIR, "main")

cd $DIR

with open(join(MAIN,"package.json")) as f:
  NAME = load(f)['productName']

def build(ico):
  npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/
  npx --yes electron-packager ./main --overwrite --icon=$DIR/app.@(ico) --prune=true --out=$DIR/app --asar

def darwin():
  build("icns")
  cd $DIR/app
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
darwin()
