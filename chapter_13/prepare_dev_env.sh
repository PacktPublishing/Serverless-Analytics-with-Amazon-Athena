#!/bin/bash

# Copyright (C) 2019 Amazon Web Services
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cat << EOF
#
# This script will prepare your development environment by installing certain pre-requisites, namely:
#   1. Apache Maven
#   2. JDK
#   3. AWS CLI (latest version)
#   4. AWS SAM Build Tool (latest version)
#
# If you already have a subset of these installed or do not want this script to make changes to
# your development environment, we suggest editing the script or manually running its commands
# to customize your environment.
#
# This script has been designed and tested to work on Ubuntu but may require slight adjustment for other Operating Systems.
# All tools used here (except HomeBrew) are supported on all major Operating Systems: Windows, Linux, Mac OS.
#
# This script may prompt you for yes/no responses or permission to continue at verious points. It is not meant to run unattended.
#
EOF

while true; do
    read -p "Do you wish to proceed? (yes or no) " yn
    case $yn in
        [Yy]* ) echo "Proceeding..."; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

set -e
sudo wget https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz -O /tmp/apache-maven-3.5.4-bin.tar.gz
sudo tar xf /tmp/apache-maven-3.5.4-bin.tar.gz -C /opt
echo "export M2_HOME=/opt/apache-maven-3.5.4" >> ~/.profile
echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> ~/.profile
echo "export M2_HOME=/opt/apache-maven-3.5.4" >> ~/.bash_profile
echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> ~/.bash_profile
sudo rm /tmp/apache-maven-3.5.4-bin.tar.gz

sudo apt-get install openjdk-8-jdk -y || true

curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip"
unzip /tmp/awscli-bundle.zip -d /tmp/
sudo /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws || true
sudo rm -rf  /tmp/awscli-bundle*

wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip -O "/tmp/aws-sam-cli-linux-x86_64.zip"
unzip /tmp/aws-sam-cli-linux-x86_64.zip -d /tmp/sam-installation
sudo /tmp/sam-installation/install || true
sudo rm -rf /tmp/sam-installation
sudo rm -rf /tmp/aws-sam-cli-linux-x86_64.zip

echo "Select a valid Java Runtime."
sudo update-alternatives --config java

echo "Select a valid JDK."
sudo update-alternatives --config javac

aws --version
sam --version
mvn --version
java -version
javac -version

echo ""
echo ""
echo "To ensure your terminal can see the new tools we installed run \"source ~/.profile\" or open a fresh terminal."