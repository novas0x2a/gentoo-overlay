# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus, additions by Oliver Schneider. For new version look here : http://gentoo.zugaina.org/

inherit eutils

MY_PV="${PV}jo-III"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="A menu driven installer for installing Windows programs under x86 with the Linux operatin system using Wine."
DESCRIPTION_FR="Un installateur pour des programmes Windows sous Wine."
HOMEPAGE="http://www.von-thadden.de/Joachim/WineTools/"
SRC_URI="http://www.openoffice.de/wt/${MY_P}.tar.gz"

RESTRICT="nomirror"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""
SLOT="0"
DEPEND="app-emulation/wine
	>=sys-devel/gettext-0.14.1
	x11-libs/gtk+"

S=${WORKDIR}/${MY_P}

src_install() {
    sed -i 's:/usr/local/winetools:/usr/share/winetools:' findwine wt0.9jo
    dodir /usr/share /usr/bin
    mv ${S} ${D}/usr/share
    mv ${D}/usr/share/winetools-${MY_PV} ${D}/usr/share/winetools
    cat << EOF > ${D}/usr/bin/winetools
#!/bin/sh
cd /usr/share/winetools
./wt0.9jo
EOF
    dosym /usr/share/winetools/findwine /usr/bin/
    rm ${D}/usr/share/winetools/Xdialog
    dosym /usr/share/winetools/Xdialog.builtin /usr/share/winetools/Xdialog
    chmod go+rx ${D}/usr/bin/winetools
}

