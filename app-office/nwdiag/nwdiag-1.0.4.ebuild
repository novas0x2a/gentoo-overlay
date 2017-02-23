# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Simple network diagram generator"
HOMEPAGE="http://blockdiag.com/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE="+pdf"

DEPEND="
    dev-python/setuptools[${PYTHON_USEDEP}]
	>=app-office/blockdiag-1.5[pdf?,${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -i setup.py \
		-e 's/.*include_package_data.*//'

	distutils-r1_src_prepare
}
