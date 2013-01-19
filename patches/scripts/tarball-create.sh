#!/bin/bash
function __FILE__ {
    echo ${BASH_SOURCE[0]}
}
patch=${PATCH:-patch}
file=$(__FILE__)
dirname=${file%/*}

if [[ $# != 1 ]] ; then
    echo 2>&1 <<EOF 
Usage:
  $0 *ruby-tar.gz*

Untar ruby source and set it up for git.
EOF
    exit 1
fi
tar_file="$1"
if [[ ! -r "$tar_file" ]]; then
    echo "tar file: $tar_file does not exist"  2>&1
    exit 2
fi

ruby_dir=$(basename $tar_file .tar.gz)
rm -fr $ruby_dir 2>/dev/null
tar -xzf $tar_file || {
    echo "Error untarring $ruby_name" 2>&1
    exit 3
}

ruby_debugger_dir="${ruby_dir}-debugger"
# mv -v $ruby_dir $ruby_debugger_dir 
# (cd $ruby_debugger_dir && \
(cd $ruby_dir && \
    ${patch} -p1 < ${dirname}/../ruby-1.9.3-combined.patch && 
    cd .. && tar -czf ${ruby_debugger_dir}.tar.gz $ruby_dir)
rc=$?
if (( $rc == 0 )) ; then
    rm -fr $ruby_dir
fi
exit $?
