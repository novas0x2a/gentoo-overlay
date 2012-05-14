# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="allows you to track generated html files with Google Analytics web service."
HOMEPAGE="http://code.google.com/p/sphinxcontrib-googleanalytics/"
SRC_URI="http://pypi.python.org/packages/source/s/sphinxcontrib-googleanalytics/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE=""
DEPEND="dev-python/setuptools"
RDEPEND="dev-python/sphinx"
