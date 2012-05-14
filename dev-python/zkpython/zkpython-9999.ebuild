EAPI=4
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython 3.*"

inherit distutils eutils git-2

MY_PN="zookeeper"
MY_P="${MY_PN}-${PV}"

EGIT_REPO_URI="/home/mike/zookeeper"
EGIT_BRANCH="fix-crash"
EGIT_SOURCEDIR="${WORKDIR}/${MY_P}"
S="${WORKDIR}/${MY_P}/src/contrib/zkpython/src/c"


DESCRIPTION="ZooKeeper python bindings"
HOMEPAGE="http://pypi.python.org/pypi/zkpython"
SRC_URI=""
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
DEPEND="=sys-cluster/apache-zookeeper-c-3.3.4"

src_prepare() {
	cat <<EOF >setup.py
from setuptools import setup, Extension
extension = Extension( name='zookeeper', sources=['zookeeper.c'],
                       include_dirs=['/usr/include/c-client-src'],
                       libraries=['zookeeper_mt'],
                       extra_compile_args=['-Wall', '-Wextra', '-Wno-unused-parameter'],
                       )
setup( name='zookeeper', version='${PV}', ext_modules=[extension])
EOF
	default_src_prepare
}
