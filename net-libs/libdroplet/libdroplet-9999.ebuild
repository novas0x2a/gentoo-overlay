# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#!/bin/bash

EAPI=4

inherit git-2 autotools
EGIT_REPO_URI="git://github.com/scality/Droplet.git"
EGIT_BOOTSTRAP="eautoreconf"

DESCRIPTION="A cloud storage client library"
HOMEPAGE="https://github.com/scality/Droplet/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/libxml2 dev-libs/openssl"
RDEPEND="${DEPEND}"
DOCS="doc/*"
