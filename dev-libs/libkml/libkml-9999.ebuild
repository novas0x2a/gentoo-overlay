# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/google-perftools/google-perftools-1.6.ebuild,v 1.3 2010/10/13 20:14:45 maekke Exp $

EAPI=2

inherit subversion autotools eutils toolchain-funcs
ESVN_REPO_URI="http://libkml.googlecode.com/svn/trunk"

DESCRIPTION="A KML parser/generator for OGC KML 2.2"
HOMEPAGE="http://code.google.com/p/libkml/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python examples"

RDEPEND="
	dev-libs/expat
	dev-libs/boost
	dev-libs/uriparser
"

DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
"

src_prepare() {
	local filter="\S\+\(boost\|googletest\|uriparser\)\S\+"

	einfo "Removing third_party includes"
	rm -rf third_party/uriparser-0.7.5 || die

	find -name Makefile.am -print0 | \
		xargs -0 sed -i.bak \
		-e "s,-I\S\+third_party${filter},-I/,g" \
		-e "s,\S\+builddir\S\+third_party/li${filter}la,-l\1,g" \
		|| die

	einfo "Disabling third_party libs"
	sed -i.bak third_party/Makefile.am \
		-e 's/lib_LTLIBRARIES.*/lib_LTLIBRARIES = libminizip.la/' \
		-e "s/${filter}/# &/" || die

	if ! useq examples; then
		sed -i.bak Makefile.am -e 's/examples//'
	fi


	elibtoolize || die
	eautoreconf || die
}

src_configure() {
	econf \
		--disable-java \
		$(use_enable python)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog LICENSE NEWS README || die
}
