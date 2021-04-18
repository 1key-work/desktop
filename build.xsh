#!/usr/bin/env xonsh

$RAISE_SUBPROC_ERROR = True

from shutil import which
from os.path import dirname,abspath,exists,join

trace on

$DIR = DIR = dirname(abspath(__file__))
cd $DIR

npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/

ico = "icns"

npx --yes electron-packager ./main --overwrite --icon=$DIR/app.@(ico) --prune=true --out=$DIR/app --asar
