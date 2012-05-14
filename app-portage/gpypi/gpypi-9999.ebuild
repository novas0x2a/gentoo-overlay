# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils git-2

EGIT_REPO_URI="git://github.com/iElectric/g-pypi.git"

DESCRIPTION="Create Python ebuilds for Gentoo by querying The Python Package Index"
HOMEPAGE="http://code.google.com/p/g-pypi/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND="
	dev-python/unittest2
	dev-python/jinja
	dev-python/pygments
	dev-python/argparse
	dev-python/jaxml
	app-portage/metagen
	dev-python/sphinxcontrib-googleanalytics
	test? (
		dev-python/nose
		dev-python/mocker
		dev-python/mock
		dev-python/scripttest
	)
"

src_test() {
	PYTHONPATH=. "${python}" setup.py nosetests || die "tests failed"
}
