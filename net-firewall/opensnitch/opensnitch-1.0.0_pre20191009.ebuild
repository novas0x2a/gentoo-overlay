# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="2b49871a2d1b8346eba169343b29d099a9e5c355"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 git-r3 desktop

DESCRIPTION="OpenSnitch ui"
EGIT_REPO_URI="https://github.com/evilsocket/opensnitch"
HOMEPAGE="https://github.com/evilsocket/opensnitch"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/grpcio-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/grpcio-tools-1.10.1[${PYTHON_USEDEP}]
	>=dev-python/pyinotify-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/unicode-slugify-0.1.3[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.10.1[${PYTHON_USEDEP},widgets]
"

S="${S}/ui"

PATCHES=(
	"${FILESDIR}/0001-fix-the-ui-scaling.patch"
)

src_install() {
	distutils-r1_src_install
	domenu opensnitch_ui.desktop
}
