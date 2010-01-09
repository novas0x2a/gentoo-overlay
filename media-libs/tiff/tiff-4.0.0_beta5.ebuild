# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-3.8.2-r5.ebuild,v 1.2 2008/11/27 06:09:09 nerdboy Exp $

EAPI=2

inherit eutils libtool autotools

MY_P=${P/_beta/beta}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="jpeg +cxx zlib jbig opengl"

DEPEND="
	jpeg? ( >=media-libs/jpeg-6b )
	zlib? ( >=sys-libs/zlib-1.1.3-r2 )
	jbig? ( media-libs/jbigkit )
	opengl? ( x11-libs/libXt virtual/opengl virtual/glu virtual/glut )
"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-*
}

src_compile() {
	econf \
		$(use_enable cxx) \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		$(use_enable jbig) \
		--with-pic $(use_with opengl x) \
		--with-docdir=/usr/share/doc/${PF} \
			|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc README TODO VERSION
}
