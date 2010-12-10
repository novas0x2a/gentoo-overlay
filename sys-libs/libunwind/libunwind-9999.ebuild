# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libunwind/libunwind-0.99-r1.ebuild,v 1.4 2010/05/19 20:27:30 armin76 Exp $

EAPI="2"

inherit autotools eutils git flag-o-matic

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="http://savannah.nongnu.org/projects/libunwind"
SRC_URI=""
EGIT_REPO_URI="http://git.savannah.gnu.org/r/libunwind.git"
EGIT_BOOTSTRAP="eautoreconf"

LICENSE="MIT"
SLOT="7"
KEYWORDS="amd64 ia64 x86"
IUSE=""

RESTRICT="test"

src_configure() {
	append-flags -U_FORTIFY_SOURCE
	default_src_configure
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
