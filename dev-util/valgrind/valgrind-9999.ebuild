# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/valgrind/valgrind-3.5.0.ebuild,v 1.9 2010/08/19 17:58:17 ssuominen Exp $

EAPI=2

inherit autotools eutils flag-o-matic toolchain-funcs subversion

ESVN_REPO_URI="svn://svn.valgrind.org/valgrind/trunk"
ESVN_PROJECT="valgrind"
ESVN_BOOTSTRAP="NOCONFIGURE=1 sh ./autogen.sh"

DESCRIPTION="An open-source memory debugger for GNU/Linux"
HOMEPAGE="http://www.valgrind.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="mpi"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}
	!dev-util/callgrind"

src_prepare() {
	# make sure our CFLAGS are respected
	einfo "Changing configure.in to respect CFLAGS"
	sed -i -e 's:^CFLAGS="-Wno-long-long":CFLAGS="$CFLAGS -Wno-long-long":' configure.in

	# undefined references to __guard and __stack_smash_handler in VEX (bug #114347)
	einfo "Changing Makefile.all.am to disable SSP"
	sed -i -e 's:^AM_CFLAGS_BASE = :AM_CFLAGS_BASE = -fno-stack-protector :' Makefile.all.am

	# Correct hard coded doc location
	sed -i -e "s:doc/valgrind:doc/${P}:" docs/Makefile.am

	# Fix up some suppressions that were not general enough for glibc versions
	# with more than just a major and minor number.
	epatch "${FILESDIR}/valgrind-3.4.1-glibc-2.10.1.patch"

	# Respect LDFLAGS also for libmpiwrap.so (bug #279194)
	epatch "${FILESDIR}/valgrind-3.5.0-respect-LDFLAGS.patch"

	# Minimal fixes required for glibc-2.12
	epatch "${FILESDIR}/valgrind-3.5.0-stat_h.patch"

	# Regenerate autotools files
	eautoreconf
}

src_configure() {
	local myconf

	# -fomit-frame-pointer	"Assembler messages: Error: junk `8' after expression"
	#                       while compiling insn_sse.c in none/tests/x86
	# -fpie                 valgrind seemingly hangs when built with pie on
	#                       amd64 (bug #102157)
	# -fstack-protector     more undefined references to __guard and __stack_smash_handler
	#                       because valgrind doesn't link to glibc (bug #114347)
	# -ggdb3                segmentation fault on startup
	filter-flags -fomit-frame-pointer
	filter-flags -fpie
	filter-flags -fstack-protector
	replace-flags -ggdb3 -ggdb2

	# gcc 3.3.x fails to compile valgrind with -O3 (bug #129776)
	if [ "$(gcc-version)" == "3.3" ] && is-flagq -O3; then
		ewarn "GCC 3.3 cannot compile valgrind with -O3 in CFLAGS, using -O2 instead."
		replace-flags -O3 -O2
	fi

	if use amd64 || use ppc64; then
		! has_multilib_profile && myconf="${myconf} --enable-only64bit"
	fi

	# Don't use mpicc unless the user asked for it (bug #258832)
	if ! use mpi; then
		myconf="${myconf} --without-mpicc"
	fi

	econf ${myconf} || die "Configure failed!"
}

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
	dodoc AUTHORS FAQ.txt NEWS README*
}

pkg_postinst() {
	if use ppc || use ppc64 || use amd64 ; then
		ewarn "Valgrind will not work on ppc, ppc64 or amd64 if glibc does not have"
		ewarn "debug symbols (see https://bugs.gentoo.org/show_bug.cgi?id=214065"
		ewarn "and http://bugs.gentoo.org/show_bug.cgi?id=274771)."
		ewarn "To fix this you can add splitdebug to FEATURES in make.conf and"
		ewarn "remerge glibc."
	fi
}
