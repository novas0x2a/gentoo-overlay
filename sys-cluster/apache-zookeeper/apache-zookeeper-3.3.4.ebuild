# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

MY_PN="${PN/apache-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ZooKeeper is a high-performance coordination service for
distributed applications."
HOMEPAGE="http://hadoop.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${MY_P}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
#RESTRICT="mirror binchecks"
RESTRICT="mirror"
IUSE=""

COMMON_DEP="
        >=dev-java/log4j-1.2.15[jmx]"

RDEPEND=" >=virtual/jre-1.6
  >=dev-java/jline-0.9.94
  ${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
  ${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

DATA_DIR=/var/db/"${PN}"

java_prepare() {
	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jar-from log4j
}

src_install() {
	java-pkg_newjar build/${MY_P}.jar ${PN}.jar || die
	use source && java-pkg_dosrc src/java/main/org

	dodir "${DATA_DIR}" || die
	dobin bin/zk*.sh || die
	sed "s:^dataDir=.*:dataDir=${DATA_DIR}:" conf/zoo_sample.cfg > conf/zoo.cfg || die "sed failed"
	insinto /etc/zookeeper || die
	doins conf/* || die
	newinitd "${FILESDIR}/init" "${PN}" || die
}

pkg_postinst() {
	elog "For info on configuration see http://hadoop.apache.org/${MY_PN}/docs/r${PV}"
}
