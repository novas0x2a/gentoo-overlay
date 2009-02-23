# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/geos/geos-3.0.3.ebuild,v 1.1 2008/11/27 11:36:57 bicatali Exp $

inherit eutils subversion autotools

ESVN_REPO_URI="http://svn.osgeo.org/geos/trunk"
#ESVN_BOOTSTRAP="sh ./autogen.sh"

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="http://geos.refractions.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc python ruby"

RDEPEND="ruby? ( virtual/ruby )
	python? ( virtual/python )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )\
	ruby?  ( >=dev-lang/swig-1.3.29 )
	python? ( >=dev-lang/swig-1.3.29 )"

src_unpack() {
	subversion_src_unpack
	eautoreconf
}

src_compile() {
	local myconf

	if ! use python && ! use ruby ; then
		myconf="--disable-swig"
	fi

	econf ${myconf} \
		$(use_enable python) \
		$(use_enable ruby)
	emake || die "emake failed"
	if use doc; then
		cd "${S}/doc"
		emake doxygen-html || die "doc generation failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO || die
	if use doc; then
		cd "${S}/doc"
		dohtml -r doxygen_docs/html/* || die
	fi
}
