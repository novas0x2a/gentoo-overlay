# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2

DESCRIPTION="Asynchronous event-driven network application framework and tools"
HOMEPAGE="http://www.jboss.org/netty"
SRC_URI="mirror://sourceforge/jboss/Netty%20Project/Netty%20${PV}.Final/${P}.Final-dist.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${P}.Final"

src_install() {
	java-pkg_newjar jar/${P}.Final.jar ${PN}.jar
}
