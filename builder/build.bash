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


curl -L -o bin/ForgedAlliance.exe https://github.com/fcaps/FA-Binary-Patches/releases/download/master-ce827379/ForgedAlliance.exe

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

cp -rv ./tmp/fa/changelog.md ./changelog.md

echo "copy SupComDataPath"
cp ./builder/init_TEMPLATE.lua ./bin/SupComDataPath.lua

git fetch --tags

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Get the latest tag name for the current branch
latest_tag=$(git tag -l "*-${branch_name}" | sort -t. -k 1,1n -k 2,2n -k 3,3n | tail -n 1)

echo $latest_tag

# Extract the current version number, assume the tag name is in format vX.Y.Z-<branch_name>
if [ -n "$latest_tag" ]; then
    version="${latest_tag%-*}" # remove branch name suffix
    version="${version#v}"     # remove "v" prefix
else
    version="0.0.0"
fi

# Split the version into parts
IFS='.' read -r major minor patch <<< "${version}"

# If major version is not a number, set it to 0
if ! [[ $major =~ ^[0-9]+$ ]]; then
    major=0
fi

# Increment the minor version; adjust per your version scheme
minor=$((minor + 1))

# Construct the new version number
new_version="v${major}.${minor}.0-${branch_name}"

# Confirm version name
read -p "Going to create new git tag: ${new_version}, continue (y/n)? " -n 1 -r
echo # new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add .
    git commit -S -a -m "release ${new_version}"
    git push origin

    # If user confirms, create the new tag
    git tag -s "${new_version}" -m "release tag ${new_version}"
    # Push the new tag to remote repository
    git push origin "${new_version}"
else
    echo "Tag creation cancelled."
    exit 1
fi

rm -rf tmp

