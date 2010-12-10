# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils

DESCRIPTION="Python completion helper"
HOMEPAGE="http://code.google.com/p/pysmell"
SRC_URI="http://pypi.python.org/packages/source/p/pysmell/pysmell-0.7.3.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="vim-syntax"
DEPEND="${DEPEND}
	vim-syntax? (
		|| (
			app-editors/vim[python]
			app-editors/gvim[python]
		)
	)
"

RDEPEND="${DEPEND}"


src_install() {
	distutils_src_install

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/plugin
		doins "${S}"/pysmell.vim
	fi
}
