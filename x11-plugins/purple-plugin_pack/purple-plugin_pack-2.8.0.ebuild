# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal

MY_PN=${PN/_/-}
MY_P=${MY_PN}-${PV}
DESCRIPTION="A package with many different plugins for pidgin and libpurple"
HOMEPAGE="https://keep.imfreedom.org/pidgin/purple-plugin-pack/"
SRC_URI="https://bintray.com/pidgin/releases/download_file?file_path=${MY_P}.tar.xz -> ${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gtk ncurses spell"

RDEPEND="
	dev-libs/glib
	x11-libs/gtk+:2
	dev-libs/libgnt
	x11-libs/pango
	x11-libs/cairo
	dev-libs/json-glib
	sys-libs/zlib
	net-im/pidgin[gtk?,ncurses?]
	spell? ( app-text/gtkspell:2 )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}
