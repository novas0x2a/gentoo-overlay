# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils unpacker

DESCRIPTION="A Hipchat client"
HOMEPAGE="http://www.hipchat.com/"

# Packages url:
# http://downloads.hipchat.com/linux/apt/dists/stable/main/binary-amd64/Packages
SRC_BASE="http://downloads.hipchat.com/linux/apt/pool/main/${PN:0:1}/${PN}/${PN}_${PV}"
SRC_URI="${SRC_BASE}_amd64.deb"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE="+bundled-libs"
RESTRICT="strip"

DEPEND=""
RDEPEND="
	!bundled-libs? (
		net-libs/qxmpp[hipchat]
		media-libs/libcanberra
		media-libs/libvorbis
		media-libs/libogg
		>dev-libs/libdbusmenu-qt-0.9.2[qt5]
		kde-frameworks/kidletime
		kde-frameworks/sonnet
		kde-frameworks/kwindowsystem
		~dev-qt/qtcore-5.3.2:5
		~dev-qt/qtgui-5.3.2:5
		~dev-qt/qtnetwork-5.3.2:5
		~dev-qt/qtopengl-5.3.2:5
		~dev-qt/qtwebkit-5.3.2:5
		~dev-qt/qtwidgets-5.3.2:5
		~dev-qt/qtxml-5.3.2:5
		~dev-qt/qtdbus-5.3.2:5
		~dev-qt/qtx11extras-5.3.2:5
		~dev-qt/qtdeclarative-5.3.2:5
	)
"

QA_PREBUILT="*"
S=${WORKDIR}

# This doesn't work yet.
REMOVE=""

src_prepare() {
	if ! use bundled-libs; then
		for fn in ${REMOVE[@]}; do
			rm $fn
		done
	fi
}

src_install() {
	doins -r opt
	doins -r usr

	fperms -R 0755 /opt/HipChat/bin/ /opt/HipChat/lib/hipchat.bin

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=/opt/HipChat" >> ${T}/10${PN}
	doins "${T}"/10${PN} || die
}
