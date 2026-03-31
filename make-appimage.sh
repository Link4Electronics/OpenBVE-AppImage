#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q openbve | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/leezer3/OpenBVE/refs/heads/master/graphics/logo_icon.svg
export DESKTOP=/usr/share/applications/openbve.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/openbve /usr/bin/mono /usr/lib/openbve/OpenBve.exe /usr/lib/openbve /usr/share/games/openbve /usr/lib/libmono*.so* /usr/lib/mono/4.5* #/usr/lib/mono/4.0* /usr/lib/mono/4.5*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
