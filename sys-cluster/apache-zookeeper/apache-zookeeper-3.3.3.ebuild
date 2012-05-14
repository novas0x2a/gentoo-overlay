# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

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
RESTRICT="mirror binchecks"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND="
  >=virtual/jre-1.6
  dev-java/log4j[jmx]
  >=dev-java/jline-0.9.94
"

S="${WORKDIR}/${MY_P}"

DATA_DIR=/var/db/"${PN}"

src_configure() {
	true
}

src_compile() {
	true
}

src_install() {
	java-pkg_newjar ${MY_P}.jar || die
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
