#!/usr/bin/env xonsh

$RAISE_SUBPROC_ERROR = True

from pathlib import Path
import sys
from os.path import dirname,abspath,exists,join
DIR = dirname(abspath(__file__))
sys.path.insert(0, DIR)
cd @(DIR)
trace on

from platform_simple import platform
from shutil import which
from json import load,dump

MAIN = join(DIR, "main")


with open(join(MAIN,"package.json"),encoding="utf-8") as f:
  PACKAGE = load(f)
  NAME = PACKAGE['productName']

def build(ico):
  cd @(MAIN)
  if not exists(join(MAIN, "node_modules")):
    yarn
  npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/
  npx --yes electron-packager . --overwrite --icon=@(DIR)/app.@(ico) --prune=true --out=@(DIR)/app
  # --asar
  # --extra-resource='index.html' --extra-resource='m.js' --extra-resource='s.js'
  cd @(DIR)/app

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
  dmg = "app.dmg"
  rm -rf @(dmg)
  npx --yes appdmg @(fp) @(dmg)

def win():
  
  build("ico")

  from mako.template import Template
  inno = "inno.iss"
  with open(join(DIR,inno),encoding="utf-8") as f:
    txt = Template(f.read()).render(**PACKAGE)
    with open(join(DIR,"app",inno),"w",encoding="utf-8") as o:
      o.write(txt)

  Path(NAME+"-win32-x64").rename(NAME)
  pip3 install py7zr
  import py7zr
  with py7zr.SevenZipFile("app.7z", 'w') as z:
    z.writeall('./'+NAME)

  pdir = "C:\\Program Files (x86)\\Inno Setup 6\\"
  ChineseSimplified = pdir+'Languages\\ChineseSimplified.isl'
  if not exists(ChineseSimplified):
    import urllib.request
    response = urllib.request.urlopen('https://raw.githubusercontent.com/jrsoftware/issrc/main/Files/Languages/Unofficial/ChineseSimplified.isl')
    with open(ChineseSimplified,"wb") as f:
      f.write(response.read())
  @(pdir+"ISCC.exe") .\@(inno)

def linux():
  build("png")

#locals()[platform]()
win()


