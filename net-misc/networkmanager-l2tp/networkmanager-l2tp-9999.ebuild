# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/seriyps/NetworkManager-l2tp.git"
inherit autotools git-r3

DESCRIPTION="NetworkManager L2TP plugin"
HOMEPAGE="https://github.com/seriyps/NetworkManager-l2tp"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome nls static-libs"

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	net-dialup/ppp
	>=net-misc/networkmanager-0.9.8
	sys-apps/dbus
	net-dialup/xl2tpd
	gnome? ( gnome-base/libgnome-keyring x11-libs/gtk+:3 )"

DEPEND="${RDEPEND}
	dev-perl/XML-Parser
	dev-util/intltool
	dev-lang/perl
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_with gnome) \
		--disable-more-warnings \
		--with-dist-version=Gentoo \
		--with-pic
}
