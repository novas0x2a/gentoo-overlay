# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/astng/astng-0.24.2.ebuild,v 1.5 2013/04/02 08:06:04 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2} pypy{1_9,2_0} )

inherit distutils-r1

DESCRIPTION="A parser/formatter library that's easy to use and that provides informative error messages."
HOMEPAGE="http://www.opengroove.org/parcon/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x86-macos"
IUSE="test cairo"

# Version specified in __pkginfo__.py.
RDEPEND="
	cairo? (
		dev-python/pycairo
		x11-libs/pango
	)
"
DEPEND="${RDEPEND}"
