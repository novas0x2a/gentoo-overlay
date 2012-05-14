# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools

MY_PN="${PN/apache-/}"
MY_PN="${MY_PN/-c/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ZooKeeper is a high-performance coordination service for
distributed applications."
HOMEPAGE="http://hadoop.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${MY_P}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE=""

DEPEND="dev-util/cppunit"
RDEPEND=""

S="${WORKDIR}/${MY_P}/src/c"

src_prepare() {
	eautoreconf
}
