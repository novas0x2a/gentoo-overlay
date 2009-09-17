# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=129352 - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

inherit libtool eutils flag-o-matic autotools multilib

DESCRIPTION="32bit nls-disabled dev-libs/popt-1.7"
HOMEPAGE="http://www.rpm.org/"
SRC_URI="ftp://ftp.rpm.org/pub/rpm/dist/rpm-4.1.x/popt-1.7.tar.gz"
RESTRICT="nomirror"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
DEPEND=""
RDEPEND=""

pkg_setup() {
	export ABI=x86
}

src_unpack() {
	unpack ${A}

	cd ${WORKDIR}
	mkdir ${P} # this way portage won't complain about missing directories

	cd "${WORKDIR}/popt-1.7" || die
	epatch "${FILESDIR}"/popt-1.7-missing-tests.patch || die
	epatch "${FILESDIR}"/popt-1.7-nls.patch || die

	eautomake
	elibtoolize
}

src_compile() {
	cd "${WORKDIR}/popt-1.7" || die
	econf || die "configure failed" # "--prefix=${_prefix}"
	emake || die "emake failed"
}

src_install() {
	cd "${WORKDIR}/popt-1.7" || die
	make install DESTDIR="${D}" || die
	# Don't install anything except the library itself
	rm -Rv ${D}/usr/share || die
	rm -Rv ${D}/usr/include || die
	mv ${D}/usr/lib ${D}/usr/lib32
}
