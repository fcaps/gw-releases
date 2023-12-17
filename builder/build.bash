#!/usr/bin/env bash
set -e

rel_path="$(dirname "$0")/.."
dir_path="$(realpath "$rel_path")"

# Echo the directory path
echo "Changing to directory: $dir_path"

# Change to the directory
cd "$dir_path"

echo "cleanup"
rm -rf tmp
rm -rf gamedata/*
rm -rf bin/*
mkdir tmp


curl -L -o tmp/ForgedAlliance.exe https://github.com/fcaps/FA-Binary-Patches/releases/download/master-ce827379/ForgedAlliance.exe

git clone --branch deploy/faf --single-branch --depth 1 git@github.com:FAForever/fa.git tmp/fa


echo "copy gamedata"
cp -rv ./tmp/fa/effects ./gamedata/effects
cp -rv ./tmp/fa/env ./gamedata/env
cp -rv ./tmp/fa/loc ./gamedata/loc
cp -rv ./tmp/fa/lua ./gamedata/lua
cp -rv ./tmp/fa/meshes ./gamedata/meshes
#cp -r ./fa/modules ./gamedata/modules # outdated?
cp -rv ./tmp/fa/projectiles ./gamedata/projectiles
#cp -r ./fa/schook ./gamedata/schook # not used anymore?
cp -rv ./tmp/fa/textures ./gamedata/textures
cp -rv ./tmp/fa/units ./gamedata/units
cp -rv ./tmp/fa/etc ./gamedata/etc


echo "copy SupComDataPath"
cp ./builder/init_TEMPLATE.lua ./bin/SupComDataPath.lua

rm -rf tmp

echo "finished"