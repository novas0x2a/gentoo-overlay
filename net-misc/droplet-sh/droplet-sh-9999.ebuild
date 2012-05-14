# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#!/bin/bash

EAPI=3

inherit git-2 autotools
EGIT_REPO_URI="git://github.com/scality/Droplet-sh.git"
EGIT_BOOTSTRAP="eautoreconf"

DESCRIPTION="Shell to access cloud storage via command line (w/ libdroplet)"
HOMEPAGE="https://github.com/scality/Droplet-sh/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-libs/libdroplet"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
