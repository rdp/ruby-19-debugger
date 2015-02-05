#!/bin/bash
# Create a directory with the combined Ruby patches. Do this by:
# 1. run the untar script to remove any old directory and untar Ruby
# 2. run git init and commit the initial set of files
#
if [[ $0 == ${BASH_SOURCE[0]} ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi
# set -x
BUILDDIR=${BUILDDIR:-/src/build}
SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
UNTAR_SCRIPT=$SCRIPT_DIR/untar-ruby.sh

if [[ -r  $UNTAR_SCRIPT ]] ; then
    if ! source $UNTAR_SCRIPT ; then
	return $?
    fi
fi

if [[ -z $RUBY_DIR ]] ; then
    echo "Untar script $UNTAR_SCRIPT should have created Ruby directory $RUBY_DIR" 2>&1
    return 1
fi
cd $RUBY_DIR && git init . && git add -f * && git commit -m'base' . | head
return $?
# set +x
