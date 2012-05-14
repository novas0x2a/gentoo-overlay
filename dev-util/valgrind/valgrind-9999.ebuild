# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/valgrind/valgrind-3.7.0.ebuild,v 1.1 2011/11/11 01:40:06 blueness Exp $

EAPI=4
inherit autotools eutils flag-o-matic toolchain-funcs multilib pax-utils subversion

ESVN_REPO_URI="svn://svn.valgrind.org/valgrind/branches/AVX"
ESVN_PROJECT="valgrind"
ESVN_BOOTSTRAP="NOCONFIGURE=1 sh ./autogen.sh"

DESCRIPTION="An open-source memory debugger for GNU/Linux"
HOMEPAGE="http://www.valgrind.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="mpi"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Correct hard coded doc location
	sed -i -e "s:doc/valgrind:doc/${PF}:" docs/Makefile.am || die

	# Respect CFLAGS, LDFLAGS
	epatch "${FILESDIR}"/${PN}-3.7.0-respect-flags.patch

	# Changing Makefile.all.am to disable SSP
	epatch "${FILESDIR}"/${PN}-3.7.0-fno-stack-protector.patch

	# Yet more local labels, this time for ppc32 & ppc64
	epatch "${FILESDIR}"/${PN}-3.6.0-local-labels.patch

	# Don't build in empty assembly files for other platforms or we'll get a QA
	# warning about executable stacks.
	epatch "${FILESDIR}"/${PN}-3.7.0-non-exec-stack.patch

	# Fix the regex to get gcc's version
	epatch "${FILESDIR}"/${PN}-3.7.0-fix-gcc-regex.patch

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

	if use amd64 || use ppc64; then
		! has_multilib_profile && myconf="${myconf} --enable-only64bit"
	fi

	# Don't use mpicc unless the user asked for it (bug #258832)
	if ! use mpi; then
		myconf="${myconf} --without-mpicc"
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS FAQ.txt NEWS README*

	pax-mark m "${D}"/usr/$(get_libdir)/valgrind/*-*-linux
}

pkg_postinst() {
	ewarn "Valgrind will not work if glibc does not have debug symbols."
	ewarn "To fix this you can add splitdebug to FEATURES in make.conf"
	ewarn "and remerge glibc.  See:"
	ewarn "https://bugs.gentoo.org/show_bug.cgi?id=214065"
	ewarn "https://bugs.gentoo.org/show_bug.cgi?id=274771"
	ewarn "https://bugs.gentoo.org/show_bug.cgi?id=388703"
}
