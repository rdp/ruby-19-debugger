#!/bin/bash
if [[ $0 == ${BASH_SOURCE[0]} ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi
# set -x
BUILDDIR=/src/build
RUBY_TAR_FILE=/src/archive/ruby-2.1.5.tar.gz
PATCH_SCRIPT=$(dirname ${BASH_SOURCE[0]})/patch-ruby.sh
cd $BUILDDIR && rm -fr ruby-2.1.5 && \
    tar -xpf $RUBY_TAR_FILE && \
    cd ruby-2.1.5 && $PATCH_SCRIPT combined-2.1.5
# set +x
