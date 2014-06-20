%define rubyver      1.9.3
%define rubyminorver p484

Name:		ruby19d
Version:	%{rubyver}%{rubyminorver}
Release:	2%{?dist}
License:	Ruby License/GPL - see COPYING
URL:		http://www.ruby-lang.org/
Provides:       ruby(abi) = 1.9
BuildRoot:%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:	readline readline-devel ncurses ncurses-devel gdbm gdbm-devel glibc-devel gcc unzip openssl-devel bison make ruby
Requires:	libyaml
Source0:	https://ruby-19-debugger.googlecode.com/files/ruby-%{rubyver}-%{rubyminorver}-debugger.tar.gz
Summary:	Ruby Programming Language with additional support for debuggers
Group:		Development/Languages
Requires(preun): %{_sbindir}/alternatives, /sbin/install-info
Requires(posttrans): %{_sbindir}/alternatives
Requires(post): /sbin/install-info

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
  --with-rubyhdrdir=/usr/include/ruby-1.9d \
  --with-rubylibprefix=/usr/lib/rubyd \
  --docdir=/usr/share/doc/ruby19d \
  --with-soname=ruby19d \
  --enable-shared \
  --with-ruby-version=minor \
  --disable-rpath \
  --without-X11 \
  --without-tk \
  --with-ruby_pc=ruby-1.9d.pc \
  --program-suffix=19d

make %{?_smp_mflags}

%install

# installing binaries ...
make install DESTDIR=$RPM_BUILD_ROOT

rm -f $RPM_BUILD_ROOT%{_libdir}/libruby-static.a
rm -f $RPM_BUILD_ROOT%{_libdir}/libruby.so

#we don't want to keep the src directory
rm -rf $RPM_BUILD_ROOT/usr/src

%preun
for prog in erb gem irb rake rdoc ri ruby testrb; do
    alternatives --remove $prog %{_bindir}/${prog}19d || :
done

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-, root, root)
%doc README COPYING ChangeLog LEGAL ToDo
%{_bindir}
%{_datadir}
%{_includedir}
%{_libdir}

%changelog
* Thu Jun 19 2014 Rocky Bernstein <rockyb@rubyforge.org> 1.9.3-p484-debugger-2
- Revise for p484 to make work on RHEL 7

* Mon Jan 28 2013 Rocky Bernstein <rockyb@rubyforge.org> 1.9.3-p374-debugger-3
- More aggressive with separating from ruby19.

* Tue Jan 20 2013 Rocky Bernstein <rockyb@rubyforge.org> 1.9.3-p374-debugger-2
- Remove "alternatives" code. For now it is a separate program.

* Tue Jan 19 2013 Rocky Bernstein <rockyb@rubyforge.org> 1.9.3-p374-debugger-1
- Use "alternatives" and "--slave" option and update to p374

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
