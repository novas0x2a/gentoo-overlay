#!/bin/bash

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Human-readable representations of digests"
HOMEPAGE="https://github.com/zacharyvoase/humanhash https://pypi.python.org/pypi/humanhash"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
