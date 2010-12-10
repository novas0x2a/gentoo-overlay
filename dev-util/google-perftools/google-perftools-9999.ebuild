# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/google-perftools/google-perftools-1.6.ebuild,v 1.3 2010/10/13 20:14:45 maekke Exp $

EAPI=2

inherit subversion autotools eutils toolchain-funcs
ESVN_REPO_URI="http://google-perftools.googlecode.com/svn/trunk"
ESVN_PATCHES="${FILESDIR}/*.patch"
ESVN_BOOTSTRAP="./autogen.sh"

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/google-perftools/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="largepages +debug minimal"

DEPEND="sys-libs/libunwind"
RDEPEND="${DEPEND}"

# tests get stuck in a deadlock due to sandbox interactions.
# bug #290249.
RESTRICT=test

src_configure() {
	use largepages && append-cppflags -DTCMALLOC_LARGE_PAGES

	econf \
		--disable-static \
		--disable-dependency-tracking \
		--enable-fast-install \
		$(use_enable debug debugalloc) \
		$(use_enable minimal)
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
