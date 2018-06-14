# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils rpm xdg

MY_PN=${PN/-bin}

DESCRIPTION="Free and Open Source messaging and emailing app"
HOMEPAGE="http://rambox.pro/"
SRC_URI="amd64? ( https://github.com/saenzramiro/${MY_PN}/releases/download/${PV}/${MY_PN^}-${PV}-x64.rpm -> ${P}-x64.rpm )
	x86? ( https://github.com/saenzramiro/${MY_PN}/releases/download/${PV}/${MY_PN^}-${PV}-ia32.rpm -> ${P}-ia32.rpm )"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-3"

QA_EXECSTACK="opt/${MY_PN^}/${MY_PN}"
QA_PRESTRIPPED="opt/${MY_PN^}/lib.*
	opt/${MY_PN^}/${MY_PN}"

DEPEND="dev-libs/libpcre:3
	dev-libs/libtasn1:0
	dev-libs/nettle:0
	dev-libs/nspr:0
	dev-libs/nss:0
	gnome-base/gconf:2
	media-libs/alsa-lib:0
	media-libs/libpng:0
	net-libs/gnutls:0
	x11-libs/gtk+:2
	x11-libs/libXScrnSaver:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	mv "${S}"/{opt,usr} "${D}"/ || die
}

pkg_preinst() {
	gnome2_icon_savelist
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
}