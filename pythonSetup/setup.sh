#!/bin/bash
date
# Uncomment line below if you need to debug this script
# set -o xtrace
PS4='${LINENO}: '

# Usage:
# Call bash setup.sh if you want to spawn a subprocess and avoid changing directory after this script is finished

# or

# Call using source setup.sh to persist directory changes and also persist virtual environment activation in parent shell

# References: [Script to change current directory (cd, pwd)](https://unix.stackexchange.com/a/27140)
# [Bash Source Command](https://linuxize.com/post/bash-source-command/)


# Reference to function creation and calls: https://devqa.io/create-call-bash-functions/
function initializeDirectory() {
    cd .venv312/Scripts
}

function activateEnvironment(){
    source ./activate
}

function basicSetup(){
    # where python
    
    # This should display: Python 3.12.1
    python.exe --version 
    
    # This command should display something like:
    # pip 24.0 from {repository root folder}\.venv312\Lib\site-packages\pip (python 3.12)
    python -m pip -V

    python -m pip install pip-tools

    python.exe -m pip install --upgrade pip
}

function runPipCompile(){
    # https://pip.pypa.io/en/stable/topics/secure-installs/
    # https://pip-tools.readthedocs.io/en/latest/cli/pip-compile/
    pip-compile --generate-hashes --rebuild --no-strip-extras --emit-find-links ./../../../requirements.in --output-file ./../../requirements.txt
}

function installRequiredDependencies(){
    python -m pip install -r ./../../requirements.txt
}

function freezeAllDependenciesInASeparateFile()
{
    python -m pip freeze --all > ./../../requirements_ALL.txt
}

function createEnvironment()
{
    bash create_python3.12_environment.sh "$1"
    creationCode=$?

    if [[ $creationCode != 0 ]]
    then
        echo ""
        echo "Since environment was not created correctly, the final setup of dependencies will not be performed now"
        exit 1
    fi
}

# Get the directory on which script was called
currentDirectory=$(pwd)


createEnvironment
initializeDirectory
activateEnvironment
basicSetup
runPipCompile
installRequiredDependencies
freezeAllDependenciesInASeparateFile

# Restore the directory on which script was called
cd $currentDirectory