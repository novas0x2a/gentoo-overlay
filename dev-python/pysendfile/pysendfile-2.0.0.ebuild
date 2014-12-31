
EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Python Module: pysendfile"
HOMEPAGE="http://code.google.com/p/pysendfile/"
SRC_URI="http://pysendfile.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""
