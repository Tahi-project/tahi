#!/usr/bin/env bash

export PATH="$HOME/bin:$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
rm geckodriver-v0.18.0-linux32.tar.gz

wget https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux32.tar.gz
tar -xvzf geckodriver*
chmod +x geckodriver
mv geckodriver /opt/teamcity/bin/

SCRIPT_DIR=%teamcity.build.workingDir%
ASSETS_DIR=$SCRIPT_DIR/frontend/assets

pyenv activate tahi-int3
pyenv version
cd $ASSETS_DIR
wget http://bighector.plos.org/aperta/testing_assets.tar.gz
TESTING_ASSETS="testing_assets.tar.gz"
if tar --version | grep -q 'gnu'; then
  echo "Detected GNU tar"
  tar --warning=no-unknown-keyword -vxf $TESTING_ASSETS
else
  echo "Detected non-GNU tar"
  tar -vxf $TESTING_ASSETS
fi
rm $TESTING_ASSETS
cd $SCRIPT_DIR

rm Output/*.png
rm Base/*.pyc
rm frontend/*.pyc
rm frontend/Pages/*.pyc

pytest -v -m 'deploy_verify' -n auto -l --timeout=600 --teamcity frontend

pkill firefox
pyenv deactivate
pyenv version
