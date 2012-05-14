# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#!/bin/bash

EAPI=3

ESVN_REPO_URI=http://svn.projects.otaku42.de/python-volumeid/trunk/

inherit distutils subversion

DESCRIPTION="A python extension for the blkid library"
HOMEPAGE="http://projects.otaku42.de/browser/python-volumeid/trunk/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

