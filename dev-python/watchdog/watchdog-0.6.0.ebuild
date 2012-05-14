# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Ebuild generated by g-pypi 0.1

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Cross-platform library for file update notifications"
HOMEPAGE="http://pypi.python.org/pypi/watchdog"
SRC_URI="http://pypi.python.org/packages/source/w/watchdog/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}"
