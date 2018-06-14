# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#!/bin/bash

EAPI=6

inherit git-r3

DESCRIPTION="fedora junk"
HOMEPAGE="https://ostree.readthedocs.io/"
EGIT_REPO_URI="https://github.com/ostreedev/ostree.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="curl +soup"

RDEPEND="
	dev-libs/glib
	soup? ( net-libs/libsoup )
	curl? ( net-misc/curl )
	sys-libs/libselinux
	app-crypt/gpgme
	app-arch/libarchive
	sys-fs/fuse
	app-arch/xz-utils
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison
	sys-fs/e2fsprogs
"

src_prepare() {
	default
    NOCONFIGURE=yes ./autogen.sh || die
}

src_configure() {
	econf \
		$(use_with curl) \
		$(use_with soup)
}
