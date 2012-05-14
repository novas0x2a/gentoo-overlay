# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/xdelta/xdelta-3.0.0.ebuild,v 1.8 2011/07/15 15:39:51 xarthisius Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils toolchain-funcs eutils

DESCRIPTION="a binary diff and differential compression tools. VCDIFF (RFC 3284) delta compression."
HOMEPAGE="http://xdelta.org"
SRC_URI="http://${PN}.googlecode.com/files/${P/-}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="test"

DEPEND="
  test? ( app-arch/ncompress )
  dev-lang/swig
"
RDEPEND=""

S="${WORKDIR}/${P/-}"

DOCS="draft-korn-vcdiff.txt"

src_prepare() {
	sed -i -e 's:-O3:-Wall:' setup.py || die "setup.py sed failed"
	sed \
		-e 's:-O3::g' \
		-e 's:$(CC):$(CC) $(LDFLAGS):g' \
		-e 's:CFLAGS=:CFLAGS+=:' \
		-i Makefile || die "Makefile sed failed"
	epatch ${FILESDIR}/${PV}-*.diff
	distutils_src_prepare
}

src_test() {
	if [ $UID != 0 ]; then
		emake test || die "emake test failed"
	else
		ewarn "Tests can't be run as root, skipping."
	fi
}

src_compile() {
	tc-export CC CXX
	if use swig; then
		emake xdelta3_wrap.c
	fi
	distutils_src_compile
	emake xdelta3 || die "emake xdelta3 failed"
	if use test; then
		emake xdelta3-debug || die "emake xdelta3-debug failed"
	fi
}

src_install() {
	dobin xdelta3 || die "dobin failed"
	dodoc xdelta3-test.py
	distutils_src_install
}
