# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdc1394/libdc1394-2.0.2.ebuild,v 1.1 2008/06/11 09:25:54 stefaan Exp $

inherit eutils autotools

DESCRIPTION="library for controling IEEE 1394 conforming based cameras"
HOMEPAGE="http://sourceforge.net/projects/libdc1394/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="X doc usb examples"

DEPEND=">=sys-libs/libraw1394-1.2.0
		X? ( x11-libs/libSM x11-libs/libXv )
	    doc? ( app-doc/doxygen )
		usb? ( dev-libs/libusb )"

src_unpack() {
	unpack ${A}; cd ${S}
	epatch ${FILESDIR}/${P}-*.patch
	eautoreconf
}

src_compile() {

	econf \
		--program-suffix=2 \
		$(use_with X x) \
		$(use_enable examples) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc NEWS README AUTHORS ChangeLog
}
