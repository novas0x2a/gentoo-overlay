# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Command-line YAML processor - jq wrapper for YAML documents"
HOMEPAGE="https://yq.readthedocs.io/ https://github.com/kislyuk/yq/ https://pypi.org/project/yq/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test toml"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/jq
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	toml? ( dev-python/toml[${PYTHON_USEDEP}] )
	dev-python/xmltodict[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/toml[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	if use toml; then
		sed -e 's!console_scripts.*!&\n"tq=yq:tq_cli",!' -i setup.py || die
	fi
	sed -e 's:unittest.main():unittest.main(verbosity=2):' \
		-i test/test.py || die

	sed -r -i 's:[[:space:]]*"coverage",:: ; s:[[:space:]]*"flake8",::' \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" test/test.py || die "tests failed under ${EPYTHON}"
}
