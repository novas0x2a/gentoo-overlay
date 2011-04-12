# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpano13/libpano13-2.9.17.ebuild,v 1.4 2010/12/05 16:29:41 hwoarang Exp $

EAPI=2

inherit eutils versionator java-pkg-opt-2 multilib subversion autotools

ESVN_REPO_URI="http://panotools.svn.sourceforge.net/svnroot/panotools/trunk/libpano"
ESVN_BOOTSTRAP="eautoreconf"

DESCRIPTION="Helmut Dersch's panorama toolbox library"
HOMEPAGE="http://panotools.sf.net"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="java static-libs"

DEPEND="media-libs/libpng
	media-libs/tiff
	sys-libs/zlib
	virtual/jpeg
	java? ( >=virtual/jdk-1.3 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

src_configure() {
	econf \
		$(use_with java java ${JAVA_HOME}) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README README.linux AUTHORS NEWS doc/*.txt
	if ! use static-libs; then
		find "${D}"/usr/$(get_libdir) -name '*.la' -delete || die
	fi
}

pkg_postinst() {
	ewarn "you should remerge all reverse dependencies (media-gfx/hugin and"
	ewarn "media-gfx/autopano-sift-C) as they might not work anymore"
}
