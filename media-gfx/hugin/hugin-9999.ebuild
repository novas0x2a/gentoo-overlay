# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/hugin/hugin-2010.2.0_beta1.ebuild,v 1.1 2010/07/18 13:44:18 maekke Exp $

EAPI=2
WX_GTK_VER="2.8"

inherit cmake-utils wxwidgets versionator mercurial
EHG_REPO_URI=http://hugin.hg.sourceforge.net:8000/hgroot/hugin/hugin

DESCRIPTION="GUI for the creation & processing of panoramic images"
HOMEPAGE="http://hugin.sf.net"
SRC_URI=""
LICENSE="GPL-2 SIFT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

LANGS=" bg ca cs de en_GB es fi fr hu it ja ko nl pl pt_BR ru sk sl sv uk zh_CN zh_TW"
IUSE="lapack +sift $(echo ${LANGS//\ /\ linguas_})"

CDEPEND="
	!!dev-util/cocom
	app-arch/zip
	>=dev-libs/boost-1.35.0-r5
	>=media-gfx/enblend-3.0_p20080807
	media-gfx/exiv2
	media-libs/jpeg:0
	>=media-libs/libpano13-2.9.17
	media-libs/libpng
	media-libs/openexr
	media-libs/tiff
	sys-libs/zlib
	media-libs/freeglut
	x11-libs/wxGTK:2.8[opengl,-odbc]
	lapack? ( virtual/lapack )
	sift? ( media-gfx/autopano-sift-C )"
RDEPEND="${CDEPEND}
	media-libs/exiftool"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

pkg_setup() {
	DOCS="AUTHORS README TODO"
	mycmakeargs=( $(cmake-utils_use_enable lapack LAPACK) )
}

src_install() {
	cmake-utils_src_install

	for lang in ${LANGS} ; do
		case ${lang} in
			ca) dir=ca_ES;;
			cs) dir=cs_CZ;;
			*) dir=${lang};;
		esac
		use linguas_${lang} || rm -r "${D}"/usr/share/locale/${dir}
	done
}
