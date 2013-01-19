%define rubyver      1.9.3
%define rubyminorver p374

Name:ruby19d
Version:%{rubyver}%{rubyminorver}
Release:1%{?dist}
License:Ruby License/GPL - see COPYING
URL:http://www.ruby-lang.org/
Provides:       ruby(abi) = 1.9
BuildRoot:%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:readline readline-devel ncurses ncurses-devel gdbm gdbm-devel glibc-devel gcc unzip openssl-devel bison make ruby
Source0:https://ruby-19-debugger.googlecode.com/files/ruby-%{rubyver}-%{rubyminorver}-debugger.tar.gz
Summary:Ruby Programming Language with additional support for debuggers
Group:Development/Languages
Requires(preun): %{_sbindir}/alternatives, /sbin/install-info, dev
Requires(posttrans): %{_sbindir}/alternatives
Requires(post): /sbin/install-info, dev

%description 
Ruby is the interpreted scripting language for quick and
easy object-oriented programming.  This package adds to this run-time
introspection of the call stack and inspection and stepping through
instruction sequences which make it possible to write powerful
debuggers such as trepanning.

See http://github.com/rocky/trepanning.
%prep
%setup -n ruby-%{rubyver}-%{rubyminorver}
%build
CFLAGS="$RPM_OPT_FLAGS -Wall -fno-strict-aliasing"
export CFLAGS
%configure \
  --enable-shared \
  --disable-rpath \
  --without-X11 \
  --without-tk \
  --program-suffix=19d

make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT

# installing binaries ...
make install DESTDIR=$RPM_BUILD_ROOT
rm -f $RPM_BUILD_ROOT%{_libdir}/libruby-static.a
rm -f $RPM_BUILD_ROOT%{_libdir}/libruby.so

%preun
for prog in erb gem irb rake rdoc ri ruby testrb; do
    alternatives --remove $prog %{_bindir}/${prog}19d || :
done

%posttrans
RUBY_PROG=${RUBY_PROG:-/usr/bin/ruby}

need_relink() {
    if [[ -x $RUBY_PROG  && -f $RUBY_PROG ]] ; then 
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
            if [[ -x $PROG ]] ; then 
                mv $PROG $PROG18
                alternatives --install $PROG $prog $PROG18 10
                slaves="--slave $PROG $prog $PROG18 $slaves"
            fi
        done
        
        PROG=/usr/bin/ruby
        PROG18=${PROG}18
        if [[ -x $PROG ]] ; then 
            mv $PROG $PROG18
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
        if [[ -x $PROG19 ]] ; then 
            alternatives --install $PROG $prog $PROG19 81
            slaves="--slave $PROG $prog $PROG19 $slaves"
        fi
        PROG=/usr/bin/ruby
        PROG19=${PROG}19
        if [[ -x $PROG ]] ; then 
            PROG=$PROG19
            alternatives --install $PROG $prog $PROG19 81 ${slaves}
        fi
    done
}

install_alternatives

%clean
rm -rf $RPM_BUILD_ROOT

%files 
%defattr(-, root, root)
%doc README COPYING ChangeLog LEGAL ToDo 
%{_bindir}
%{_includedir}
%{_libdir}
%{_prefix}/share/

%changelog
* Tue Jan 19 2013 Rocky Bernstein <rockyb@rubyforge.org> 1.9.3-p374-debugger-1
- Use alternatives and --slave and update to p374

* Tue Dec 25 2012 Rocky Bernstein <rockyb@rubyforge.org> 1.9.3-p327-debugger
- Port to use debugger patches
- renamed package to ruby19d
- Use "alternatives" to switch between ruby 1.8 and ruby 1.9

* Fri Jul 22 2011 Sergio Rubio <rubiojr@frameos.org> - 1.9.2p290-1
- ruby19d.spec

* Fri May 06 2011 Sergio Rubio <rubiojr@frameos.org> - 1.9.2p180-3
- fixed i386 build

* Thu May 05 2011 Sergio Rubio <rubiojr@frameos.org> - 1.9.2p180-2
- fix i386 build

* Fri Feb 18 2011 Sergio Rubio <rubiojr@frameos.org> - 1.9.2p180-1
- updated to 1.9.2p180

* Sun Dec 19 2010 Sergio Rubio <rubiojr@frameos.org> - 1.9.2p0-3
- Disable X11 support
- Disable tk support

* Fri Dec 17 2010 Sergio Rubio <rubiojr@frameos.org> - 1.9.2p0-2
- renamed package to ruby19
- ruby bin renamed to ruby19
- install using standard prefix

* Fri Nov 15 2010 Taylor Kimball <taylor@linuxhq.org> - 1.9.2-p0-1
- Initial build for el5 based off of el5 spec.
