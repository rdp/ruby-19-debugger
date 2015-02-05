#!/bin/bash
# Create a directory ready for patching. Do this by:
# 1. Removing any old untarred directory (from before) with Ruby in it.
#    This is in $BUILDDIR/$RUBY_DIR where $RUBY_DIR is derived from $RUBY_TAR_FILE
# 2. Untarring $RUBY_TAR_FILE from directory $BUILDDIR
#
if [[ $0 == ${BASH_SOURCE[0]} ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi
# set -x
BUILDDIR=${BUILDDIR:-/src/build}
RUBY_TAR_FILE=${RUBY_TAR_FILE:-/src/archive/ruby-2.1.5.tar.gz}
RUBY_SHORT=$(basename $RUBY_TAR_FILE '.tar.gz')
RUBY_DIR=${BUILDDIR}/$RUBY_SHORT
PATCH_SCRIPT=$(dirname ${BASH_SOURCE[0]})/patch-ruby.sh
if [[ ! -d $BUILDDIR ]] ; then
    echo 2>&1 "Can't find build directory ${BUILDDIR}. Stopping"
    return 1
fi
cd $BUILDDIR
if [[ -d $RUBY_DIR ]] ; then
    rm -fr $RUBY_DIR
fi
if [[ ! -f $RUBY_TAR_FILE ]] ; then
    echo 2>&1 "Can't find ruby tar file ${RUBY_TAR_FILE}. Stopping"
    return 2
fi
if ! tar -xpf $RUBY_TAR_FILE ; then
    echo 2>&1 "extraction of find ${RUBY_TAR_FILE} failed. Stopping"
    return 3
fi
if ! cd $RUBY_DIR ; then
    echo 2>&1 "Can't cd to ${RUBY_DIR}. Stopping"
    return 4
fi
