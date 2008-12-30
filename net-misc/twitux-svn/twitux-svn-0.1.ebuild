# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/twitux/twitux-0.62.ebuild,v 1.1 2008/05/29 16:11:28 welp Exp $

EAPI=1

inherit eutils subversion

ESVN_REPO_URI="http://twitux.svn.sourceforge.net/svnroot/twitux/trunk"
ESVN_PROJECT="twitux"
ESVN_BOOTSTRAP="TZ=UTC svn log -v \"\${ESVN_REPO_URI}\" >\"\${S}\"/ChangeLog; NOCONFIGURE=1 sh ./autogen.sh"

DESCRIPTION="A Twitter client for the Gnome desktop"
HOMEPAGE="http://live.gnome.org/DanielMorales/Twitux"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell gnome-keyring nls"

RDEPEND="net-libs/libsoup:2.4
	dev-libs/libxml2
	gnome-base/gconf
	>=x11-libs/gtk+-2.14.0:2
	>=dev-libs/glib-2.15.5:2
	dev-libs/dbus-glib
	>=media-libs/libcanberra-0.4
	spell? ( >=app-text/enchant-1.2.0 app-text/iso-codes )
	gnome-keyring? ( gnome-base/gnome-keyring )
"

DEPEND="${RDEPEND}
	nls? ( >=dev-util/intltool-0.35.0 )
	>=dev-util/pkgconfig-0.14.0
	>=sys-devel/automake-1.9
	>=sys-devel/autoconf-2.53
	sys-devel/libtool
	app-text/gnome-doc-utils
	gnome-base/gnome-common
"

RDEPEND="${RDEPEND} !net-misc/twitux"


pkg_setup() {
	local fail="Re-emerge media-libs/libcanberra with USE gtk."
	if ! built_with_use media-libs/libcanberra gtk; then
		eerror "${fail}"
		die "${fail}"
	fi
}

src_compile() {
	econf $(use_enable spell) \
		  $(use_enable gnome-keyring) \
		  $(use_enable nls) \
		  --disable-scrollkeeper || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO ChangeLog
}
