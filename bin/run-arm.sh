#!/bin/sh
SCRIPTPATH=$(cd "$(dirname "$0")"; pwd)

# set link

path="$SCRIPTPATH/src/github.com/fivernote"
if [ ! -d "$path" ]; then
	mkdir -p "$path"
fi
rm -rf $SCRIPTPATH/src/github.com/fivernote/fivernote # 先删除
ln -s ../../../../ $SCRIPTPATH/src/github.com/fivernote/fivernote

# set GOPATH
export GOPATH=$SCRIPTPATH

script="$SCRIPTPATH/fivernote-linux-arm"
chmod 777 $script
$script -importPath github.com/fivernote/fivernote
