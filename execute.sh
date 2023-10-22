#! /usr/bin/env bash
set -e # stop the execution of the script if it fails

sudo su

cd /vagrant

cp master.sh ~/

cd ~

chmod u+x ./master.sh

./master.sh emma emma90