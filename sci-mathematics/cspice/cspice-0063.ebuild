# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs
DESCRIPTION="Library for handling spice kernels"
HOMEPAGE="http://naif.jpl.nasa.gov/naif/toolkit.html"

# The tarball isn't versioned. LAME.
SRC_URI="ftp://naif.jpl.nasa.gov/pub/naif/toolkit//C/PC_Linux_GCC_64bit/packages/${PN}.tar.Z -> ${P}.tar.Z"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="sys-devel/libtool"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/*.patch
	cp "${FILESDIR}"/Makefile "${S}"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" -j1 || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
}
