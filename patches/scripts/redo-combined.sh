#!/bin/bash
# Create a directory with the combined Ruby patches. Do this by:
# 1. Untarring Ruby via untar-ruby.sh
# 2. Running the $PATCH_SCRIPT
#
if [[ $0 == ${BASH_SOURCE[0]} ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi
# set -x
BUILDDIR=${BUILDDIR:-/src/build}
RUBY_TAR_FILE=${RUBY_TAR_FILE:-/src/archive/ruby-2.1.5.tar.gz}
RUBY_DIR=$(basename $RUBY_TAR_FILE '.tar.gz')
SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
UNTAR_SCRIPT=${SCRIPT_DIR}/untar-ruby.sh
PATCH_SCRIPT=${SCRIPT_DIR}/patch-ruby.sh

if [[ ! -d $SCRIPT_DIR ]] ; then
    echo 2>&1 "Can't find untar script directory ${SCRIPT_DIR}. Stopping"
    return 1
fi

if [[ ! -r $UNTAR_SCRIPT ]] ; then
    echo 2>&1 "Can't find untar script ${BUILDDIR}. Stopping"
    return 2
fi

if ! source $UNTAR_SCRIPT ; then
    echo 2>&1 "Trouble running ${UNTAR_SCRIPT}. Stopping"
    return 3
fi

RUBY_VERSION=$(echo $RUBY_SHORT | sed -e 's/^ruby-//')
if [[ -x $PATCH_SCRIPT ]] ; then
    $PATCH_SCRIPT combined-$RUBY_VERSION
elif [[ ! -r $PATCH_SCRIPT ]] ; then
    echo 2>&1 "Can't read patch script ${PATCH_SCRIPT} Stopping"
    return 4
else
    $PATCH_SCRIPT combined-$RUBY_VERSION
fi
return $?
# set +x
