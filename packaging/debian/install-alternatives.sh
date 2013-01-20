#!/bin/bash
# Set up alternatives. We don't want to do this just yet automatically.
# When that's the case, change this to "postinst"
set -e

case "$1" in
    configure)
	# continue below
    ;;

    abort-upgrade|abort-remove|abort-deconfigure)
	exit 0
    ;;

    *)
	echo "postinst called with unknown argument \`$1'" >&2
	exit 0
    ;;
esac

#DEBHELPER#

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
                slaves="--slave $PROG $prog $PROG18 $slaves"
            fi
        done
        
        PROG=/usr/bin/ruby
        PROG18=${PROG}18
        if [ -x $PROG ]  ; then 
           [ ! -L $PROG ] && mv $PROG $PROG18
            update-alternatives --install $PROG $prog $PROG18 10 ${slaves}
        fi

    fi
}

install_alternatives() {
    relink_ruby18
    slaves=''
    for prog in erb gem irb rake rdoc ri testrb; do
        PROG=/usr/bin/$prog
        PROG19=${PROG}19d
        if [ -x $PROG19 ] ; then 
            slaves="--slave $PROG $prog $PROG19 $slaves"
        fi
    done
    PROG=/usr/bin/ruby
    PROG19=${PROG}19d
    if [ -x $PROG ] ; then 
        update-alternatives --install $PROG ruby ${PROG19} 81 ${slaves}
    fi
}

install_alternatives

exit 0
