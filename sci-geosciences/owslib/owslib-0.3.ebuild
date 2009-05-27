# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/chaco/chaco-3.0.1.ebuild,v 1.1 2009/01/15 10:26:01 bicatali Exp $

EAPI=2
inherit distutils

MY_PN="OWSLib"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="OWSLib provides a common API for accessing service metadata and wrappers for WMS."
HOMEPAGE="http://trac.gispython.org/projects/PCL/wiki/OwsLib"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

RDEPEND=""
DEPEND=""

RESTRICT=test
S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="owslib"
