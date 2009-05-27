# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/electricsheep/electricsheep-2.6.8-r1.ebuild,v 1.1 2008/04/03 13:32:44 dragonheart Exp $

inherit eutils flag-o-matic kde-functions autotools

DESCRIPTION="realize the collective dream of sleeping computers from all over the internet"
HOMEPAGE="http://electricsheep.org/"
SRC_URI="http://electricsheep.org/${P}.tar.gz"
IUSE="kde gnome"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="x11-libs/libXv
	x11-libs/libICE
	x11-libs/libSM
	dev-libs/expat
	net-misc/curl
	media-libs/jpeg
	media-libs/libpng
	media-libs/libsdl
	virtual/libc
	sys-libs/zlib"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-libs/libXt
	sys-apps/groff
	dev-lang/perl
	media-libs/libmpeg2
	sys-devel/libtool"

src_unpack() {
	unpack ${A}
	# Detect PIC requirement from direct from compiler instead of
	# macro PIC.
	sed -i -e 's/def PIC/def __PIC__/' "${S}"/mpeg2dec/src/cpu_accel.c
	epatch "${FILESDIR}"/${P}-cflagsfix.patch
	epatch "${FILESDIR}"/${P}-multihead.patch
	cd "${S}"
	eautoreconf
}

# Also detects and ties in sys-libs/slang, media-libs/aalib media-libs/svgalib and nas
# if they exist on the user machine although these aren't deps.

src_install() {

	# prevent writing for xscreensaver
	sed -i "s/^install-data-local:$/install-data-local:\nmy-install-data-local:/" \
		Makefile || die "sed Makefile failed"

	# install the xscreensaver config file
	insinto /usr/share/xscreensaver/config
	doins electricsheep.xml

	emake install DESTDIR="${D}" || die "make install failed"

	dodir /usr/share/electricsheep
	if [ ! -f /usr/share/electricsheep/electricsheep-uniqueid ]
	then
		"${D}/usr/bin/uniqueid" > \
			"${D}/usr/share/electricsheep/electricsheep-uniqueid"
	fi

	if use gnome;
	then
		insinto /usr/share/applications/screensavers
		doins "${FILESDIR}/${PN}.desktop"
	fi

	if use kde;
	then
		set-kdedir
		insinto "${KDEDIR}//share/applnk/System/ScreenSavers"
		doins "${FILESDIR}/${PN}.desktop"
	fi

	# remove header files that are installed over libmpeg2
	rm -rf "${D}/usr/include"
}
