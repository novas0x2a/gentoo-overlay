# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games autotools

DESCRIPTION="configurable talking graphical cow (inspired by cowsay)"
HOMEPAGE="http://www.doof.me.uk/xcowsay/"
SRC_URI="http://www.nickg.me.uk/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="dbus"

RDEPEND="dbus? ( sys-apps/dbus )
	games-misc/fortune-mod"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/*.patch
	eautoreconf
}

src_compile() {
	econf $(use_enable dbus) || die "configuration failed"

	emake || die "compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
}
