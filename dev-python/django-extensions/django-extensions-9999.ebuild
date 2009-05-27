# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5
EAPI=2

inherit distutils git

EGIT_PROJECT="django-extensions"
EGIT_REPO_URI="git://github.com/django-extensions/django-extensions.git"
EGIT_BRANCH="master"

DESCRIPTION="This is a repository for collecting global custom management extensions for the Django Framework. "
HOMEPAGE="http://code.google.com/p/django-command-extensions/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND="${DEPEND}
	dev-python/django
"
RDEPEND="${DEPEND}"
