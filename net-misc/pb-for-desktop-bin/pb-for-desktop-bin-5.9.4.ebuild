# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit unpacker

MY_PN="${PN%-bin}"

DESCRIPTION="PushBullet notifications for linux"
HOMEPAGE="https://sidneys.github.io/pb-for-desktop/"
SRC_URI="https://github.com/sidneys/pb-for-desktop/releases/download/v${PV}/${MY_PN}-${PV}-amd64.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="strip preserve-libs mirror"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	mv * "${ED}" || die
	dosym "/opt/PB for Desktop/pb-for-desktop" /opt/bin/pb-for-desktop
}
