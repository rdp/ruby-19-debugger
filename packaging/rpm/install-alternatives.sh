#!/bin/bash
RUBY_PROG=${RUBY_PROG:-/usr/bin/ruby}

need_relink() {
    if [ -x $RUBY_PROG ] && [ -f $RUBY_PROG ] ; then 
        $RUBY_PROG -v | grep '^ruby 1\.8\.'
        if (( $? == 0 )) ; then
                return 0
                else
                # echo "Don't have 1.8.x"
                return 1
                fi
    else
        # echo "Can't find $RUBY_PROG"
        return 2
    fi
}

relink_ruby18() {
    output=$(need_relink)
    if (( $? == 0 )) ; then
        slaves=''
        for prog in erb gem irb rake rdoc ri ruby testrb; do
            PROG=/usr/bin/$prog
            PROG18=${PROG}18
            if [ -x $PROG ] ; then 
                [ ! -L $PROG ] && mv $PROG $PROG18
                alternatives --install $PROG $prog $PROG18 10
                slaves="--slave $PROG $prog $PROG18 $slaves"
            fi
        done
        
        PROG=/usr/bin/ruby
        PROG18=${PROG}18
        if [ -x $PROG ] ; then 
            [ ! -L $PROG ] && mv $PROG $PROG18
            alternatives --install $PROG $prog $PROG18 10 ${slaves}
        fi

    fi
}

install_alternatives() {
    relink_ruby18
    slaves=''
    for prog in erb gem irb rake rdoc ri ruby testrb; do
        PROG=/usr/bin/$prog
        PROG19=${PROG}19d
        if [ -x $PROG19 ] ; then 
            alternatives --install $PROG $prog $PROG19 81
            slaves="--slave $PROG $prog $PROG19 $slaves"
        fi
        PROG=/usr/bin/ruby
        PROG19=${PROG}19
        if [ -x $PROG ] ; then 
            alternatives --install $PROG ruby $PROG19 81 ${slaves}
        fi
    done
}

install_alternatives
