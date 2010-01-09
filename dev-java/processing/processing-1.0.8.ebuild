# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

DESCRIPTION="an open source programming language and environment for people who want to program images, animation, and sound"
HOMEPAGE="http://processing.org/"
SRC_URI="http://processing.org/download/${P}.tgz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RESTRICT="strip"

DEPEND=">=virtual/jdk-1.5
	dev-java/antlr"
#	dev-java/jna
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"

QA_EXECSTACK="usr/share/processing/libraries/serial/library/librxtxSerial.so"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rf java || die

	java-pkg_jar-from --into lib antlr
	# java-pkg_jar-from --into lib ecj
	# java-pkg_jar-from --into lib jna
	sed -i -e '/^browser.linux/s:mozilla:xdg-open:' lib/preferences.txt || die
}

src_install() {
	java-pkg_addcp '$(java-config --tools)'
	java-pkg_dojar lib/*.jar

	rm -rf lib/*.jar
	insinto "${JAVA_PKG_JARDEST}"
	doins -r lib/*

	#for jar in $(find libraries -name '*.jar') ; do
	#	java-pkg_jarinto "${JAVA_PKG_SHAREPATH}/$(dirname ${jar})"
	#	java-pkg_dojar "${jar}"
	#	rm "${jar}"
	#done
	libopts -m0755
	for lib in $(find libraries -name '*.so') ; do
		java-pkg_sointo "${JAVA_PKG_SHAREPATH}/$(dirname ${lib})"
		java-pkg_doso "${lib}"
		rm "${lib}"
	done

	insinto "${JAVA_PKG_SHAREPATH}"
	doins -r libraries examples

	#java-pkg_doexamples examples/*
	#dosym /usr/share/doc/${PF}/examples "${JAVA_PKG_SHAREPATH}/examples"

	java-pkg_dohtml reference/*
	dosym /usr/share/doc/${PF}/html "${JAVA_PKG_SHAREPATH}/reference"

	java-pkg_dolauncher ${PN} --main processing.app.Base --pwd "${JAVA_PKG_SHAREPATH}"

	dodoc revisions.txt
}
