# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
JAVA_PKG_IUSE="source"

JAVA_PKG_STRICT=1

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

# zookeeper assumes that jmx classes exist in log4j
COMMON_DEP="
  >=dev-java/log4j-1.2.15[jmx]
  >=dev-java/jline-0.9.94
  >=dev-java/slf4j-api-1.6.1
  >=dev-java/netty-3.2.2
"

RDEPEND=" >=virtual/jre-1.6
  ${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
  ${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

DATA_DIR=/var/db/"${PN}"

java_prepare() {
	# We don't want ivy to run at all (we handle the deps ourselves), so this
	# removes ivy as a dep from the compile target
	sed -i -e 's/ivy-retrieve,clover,build-generated/clover,build-generated/' build.xml

	# Delete all jars to make sure we don't use a cached one
	einfo "Removing prebuilt jars"
	find "${S}" -name '*.jar' -print -delete

	java-ant_rewrite-bootclasspath auto

	## Link the jars we need for build into the tree
	cd "${S}/src/java/lib"
	java-pkg_jar-from log4j
	java-pkg_jar-from jline
	java-pkg_jar-from slf4j-api
	java-pkg_jar-from netty

	# This is required or the build attempts to use svn
	echo 'echo "lastRevision=RELEASE" > $1' > "$S/src/lastRevision.sh"

	cd "${S}"
	epatch "${FILESDIR}"/0001-make-grep-not-stupid.patch
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