# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rpy/rpy-2.0.8.ebuild,v 1.2 2009/12/21 03:37:08 arfrever Exp $

EAPI="2"

inherit distutils git

EGIT_REPO_URI="http://github.com/jcrocholl/pep8.git"
DESCRIPTION="pep8 is a tool to check your Python code against some of the style conventions in PEP 8."
HOMEPAGE="http://pypi.python.org/pypi/pep8"
SRC_URI=""

LICENSE="MIT" #Actually Expat. But whatever, they're the same.
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
