# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/electricsheep/electricsheep-2.6.8-r1.ebuild,v 1.1 2008/04/03 13:32:44 dragonheart Exp $

EAPI=1

inherit eutils autotools subversion

ESVN_REPO_URI="https://electricsheep.svn.sourceforge.net/svnroot/electricsheep/trunk/client"

DESCRIPTION="realize the collective dream of sleeping computers from all over the internet"
HOMEPAGE="http://electricsheep.org/"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="
	dev-util/glade
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	dev-libs/expat
	x11-misc/flam3
	media-video/ffmpeg"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/libtool"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${P}"-*
	eautoreconf
}

src_compile() {
	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto `pkg-config --variable themesdir gnome-screensaver`
	doins electricsheep.desktop

	exeinto `pkg-config --variable privlibexecdir gnome-screensaver`
	doexe electricsheep-saver
}
