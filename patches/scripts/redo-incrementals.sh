#!/bin/bash
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
RUBY_VERSION=$(echo $RUBY_SHORT | sed -e 's/^ruby-//')
cd $RUBY_DIR && $PATCH_SCRIPT $RUBY_VERSION
# set +x
