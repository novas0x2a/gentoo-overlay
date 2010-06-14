# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipython/ipython-0.9.1.ebuild,v 1.4 2009/01/04 18:19:28 armin76 Exp $

NEED_PYTHON=2.5

inherit distutils git

EGIT_REPO_URI="http://github.com/novas0x2a/postr.git"

DESCRIPTION="A small gtk+-based flickr uploader"
HOMEPAGE="http://burtonini.com/blog/computers/postr"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="spell"

RDEPEND="
	dev-python/gnome-python
	dev-python/pygtk
	dev-python/twisted-web
	spell? ( dev-python/gtkspell-python )
"
