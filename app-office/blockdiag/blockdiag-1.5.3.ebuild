EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Simple block diagram generator"
HOMEPAGE="http://blockdiag.com/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE="+pdf"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/webcolors[${PYTHON_USEDEP}]
	dev-python/funcparserlib[${PYTHON_USEDEP}]
	pdf? (
		dev-python/reportlab[${PYTHON_USEDEP}]
	)
"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -i setup.py \
		-e 's/.*include_package_data.*//'

	distutils-r1_src_prepare
}
