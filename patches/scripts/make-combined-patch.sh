#!/bin/bash
if [[ $0 == ${BASH_SOURCE[0]} ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi
# set -x
BUILDDIR=/src/build
RUBY_TAR_FILE=/src/archive/ruby-2.1.5.tar.gz
CODE_DIR=$(dirname ${BASH_SOURCE[0]})
REDO_INCREMENTALS=$CODE_DIR/redo-incrementals.sh
PATCH_SCRIPT=$CODE_DIR/patch-ruby.sh

cd $BUILDDIR && rm -fr ruby-2.1.5 && \
    tar -xpf $RUBY_TAR_FILE && \
    cd ruby-2.1.5
if [[ $(pwd) == ${BUILDDIR}/ruby-2.1.5 ]]; then
    git init .
    git add -f *
    git commit -m'Base commit' . | head -5
    $PATCH_SCRIPT 2.1.5
    if (( $? == 0 )) ; then
	git add brkpt.c frame.c test/debugger-ext/*
	chmod +x test/debugger-ext/testit.sh
	git commit -m'For combined patches'
	PAGER=cat git diff HEAD^ > $CODE_DIR/../ruby-2.1.5-combined-next.patch
    fi
fi
