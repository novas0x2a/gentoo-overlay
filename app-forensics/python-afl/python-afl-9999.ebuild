# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jsonrpclib/jsonrpclib-9999.ebuild,v 1.1 2012/04/18 14:54:21 vapier Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit distutils-r1

#if LIVE
EGIT_REPO_URI="http://bitbucket.org/jwilk/${PN}.git"
inherit git-r3
#endif

#if [[ ${PV} == "9999" ]] ; then
#	EGIT_REPO_URI="http://bitbucket.org/jwilk/python-afl.git"
#	inherit git-2
#else
#	SRC_URI="mirror://gentoo/${P}.tar.bz2"
#	KEYWORDS="~amd64 ~arm ~x86"
#fi

DESCRIPTION="enable American fuzzy lop instrumentation of Python modules."
HOMEPAGE="https://bitbucket.org/jwilk/python-afl"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
