# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/google-perftools/google-perftools-1.5.ebuild,v 1.1 2010/01/31 00:33:24 flameeyes Exp $

inherit subversion autotools eutils
ESVN_REPO_URI="http://google-perftools.googlecode.com/svn/trunk"

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/google-perftools/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/libunwind"
RDEPEND="${DEPEND}"

# tests get stuck in a deadlock due to sandbox interactions.
# bug #290249.
RESTRICT=test

src_unpack() {
	subversion_src_unpack
	epatch "${FILESDIR}/"*.diff
	eautoreconf
	elibtoolize
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	# Remove the already-installed documentation, since it does not
	# follow our guidelines (doesn't use ${PF}, is not configurable
	# and so on so forth).
	rm -rf "${D}"/usr/share/doc/${PN}-* || die

	dodoc README AUTHORS ChangeLog TODO README_windows.txt || die
	pushd doc
	dohtml -r * || die
	popd
}
