# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/electricsheep/electricsheep-2.6.8-r1.ebuild,v 1.1 2008/04/03 13:32:44 dragonheart Exp $

inherit autotools subversion

ESVN_REPO_URI="https://flam3.svn.sourceforge.net/svnroot/flam3/trunk/src"

DESCRIPTION="realize the collective dream of sleeping computers from all over the internet"
HOMEPAGE="http://electricsheep.org/"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="
sys-libs/zlib
media-libs/libpng
dev-libs/libxml2
media-libs/jpeg"

DEPEND="${RDEPEND}
sys-devel/libtool"

src_unpack() {
	subversion_src_unpack
	mkdir "${S}"/m4
	eautoreconf
}

src_compile() {
	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
