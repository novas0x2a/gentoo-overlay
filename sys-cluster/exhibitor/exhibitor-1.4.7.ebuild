# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN=exhibitor-standalone

DESCRIPTION="Exhibitor is a supervisor system for ZooKeeper."
HOMEPAGE="https://github.com/Netflix/exhibitor"
SRC_URI="http://central.maven.org/maven2/com/netflix/${PN}/${MY_PN}/${PV}/${MY_PN}-${PV}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

CDEPEND="
"

RDEPEND="
	>=virtual/jre-1.7
	${CDEPEND}"
DEPEND="
	>=virtual/jdk-1.7
	${CDEPEND}"

S="${WORKDIR}"

java_prepare() {
	cp -v "${FILESDIR}"/maven-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/org
}
