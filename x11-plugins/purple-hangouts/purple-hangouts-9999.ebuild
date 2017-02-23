# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
EHG_REPO_URI=https://bitbucket.org/EionRobb/purple-hangouts

inherit mercurial

DESCRIPTION="A hangouts plugin for lubpurple"
HOMEPAGE="https://bitbucket.org/EionRobb/purple-hangouts/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	=net-im/pidgin-2*
	dev-libs/json-glib
	dev-libs/protobuf-c
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_install() {
	PLUGINS=$(pkg-config --variable=plugindir purple)
	ICONS=$(pkg-config --variable=datadir purple)/pixmaps/pidgin/protocols

	dodir "$PLUGINS"
	for size in 16 22 48; do
		dodir "$ICONS/${size}"
	done
	default
}
