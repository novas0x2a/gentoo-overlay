# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Edit Jira issues as text files locally."
HOMEPAGE="https://pypi.python.org/pypi/jirafs/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	>=dev-python/jira-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/blessings-1.5.0[${PYTHON_USEDEP}]
	<dev-python/blessings-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/ipdb-0.8[${PYTHON_USEDEP}]
	<dev-python/ipdb-1.0[${PYTHON_USEDEP}]
	>=dev-python/environmental-override-0.1.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPENDS}"
