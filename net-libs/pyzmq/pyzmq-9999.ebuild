# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="*:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils git

EGIT_REPO_URI="http://github.com/zeromq/pyzmq.git"

DESCRIPTION="PyZMQ is a lightweight and super-fast messaging library built on top of the ZeroMQ library"
HOMEPAGE="http://www.zeromq.org/bindings:python http://pypi.python.org/pypi/pyzmq"
SRC_URI=""

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="=net-libs/zeromq-9999"
# dev-python/cython required only as long as pyzmq-2.0.10.1-python-3.2.patch is applied.
DEPEND="${RDEPEND}
	dev-python/cython"

DOCS="README.rst"
PYTHON_MODNAME="zmq"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-python-2.7.patch"
	epatch "${FILESDIR}/${P}-python-3.1.patch"
	epatch "${FILESDIR}/${P}-python-3.2.patch"
}

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" nosetests -sv $(ls -d build-${PYTHON_ABI}/lib.*)
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml -r docs/build/html/* || die "Installation of documentation failed"
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
