# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils subversion

DESCRIPTION="Bitten is a Python-based framework for collecting software metrics via continuous integration."
HOMEPAGE="http://bitten.edgewall.org"
ESVN_REPO_URI="http://svn.edgewall.org/repos/bitten/trunk"

LICENSE="trac"
KEYWORDS="~x86 ~amd64"
IUSE=""

SLOT="0"

DEPEND=">=dev-python/setuptools-0.6_rc1"
RDEPEND="${RDEPEND}"

src_install() {
	distutils_src_install --single-version-externally-managed
}

src_test() {
	"${python}" setup.py test || die "tests failed"
}

pkg_postinst() {
	elog "To enable the Bitten plugin in your Trac environments, you have to add:"
	elog "    [components]"
	elog "    bitten.* = enabled"
	elog "to your trac.ini files."
}
