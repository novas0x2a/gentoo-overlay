# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/systemtap/systemtap-2.5.ebuild,v 1.1 2014/08/06 05:42:26 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit linux-info autotools eutils python-single-r1 git-r3

DESCRIPTION="A linux trace/probe tool"
HOMEPAGE="http://www.sourceware.org/systemtap/"
EGIT_REPO_URI="git://sourceware.org/git/systemtap.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="sqlite"

RDEPEND=">=dev-libs/elfutils-0.142
	sys-libs/libcap
	${PYTHON_DEPS}
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.18.2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CONFIG_CHECK="~KPROBES ~RELAY ~DEBUG_FS"
ERROR_KPROBES="${PN} requires support for KProbes Instrumentation (KPROBES) - this can be enabled in 'Instrumentation Support -> Kprobes'."
ERROR_RELAY="${PN} works with support for user space relay support (RELAY) - this can be enabled in 'General setup -> Kernel->user space relay support (formerly relayfs)'."
ERROR_DEBUG_FS="${PN} works best with support for Debug Filesystem (DEBUG_FS) - this can be enabled in 'Kernel hacking -> Debug Filesystem'."

DOCS="AUTHORS HACKING NEWS README"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--without-rpm \
		--disable-server \
		--disable-docs \
		--disable-refdocs \
		--disable-grapher \
		$(use_enable sqlite)
}