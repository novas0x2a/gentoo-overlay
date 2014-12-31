# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/slf4j-api/slf4j-api-1.5.11.ebuild,v 1.4 2010/05/26 18:50:06 pacho Exp $

EAPI="4"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Simple Logging Facade for Java"
HOMEPAGE="http://www.slf4j.org/"
SRC_URI="http://www.slf4j.org/dist/${P/-log4j12/}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

COMMON_DEP="~dev-java/slf4j-api-${PV}:0
>=dev-java/log4j-1.2.16"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"

EANT_GENTOO_CLASSPATH="slf4j-api log4j"

S="${WORKDIR}/${P/-log4j12/}"

java_prepare() {
	cp -v "${FILESDIR}"/${PV}-build.xml build.xml || die

	# for ecj-3.5
	java-ant_rewrite-bootclasspath auto

	cd "${S}"
	rm *.jar integration/lib/*.jar
}

src_install() {
	java-pkg_newjar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc org
}
