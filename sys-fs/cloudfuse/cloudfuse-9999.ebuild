# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#!/bin/bash

EAPI=4

inherit git-2
EGIT_REPO_URI="git://github.com/redbo/cloudfuse.git"

DESCRIPTION="Cloudfuse is a FUSE application which provides access to Rackspace's Cloud Files (or any installation of Swift)."
HOMEPAGE="http://redbo.github.com/cloudfuse/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DOCS=( README )

DEPEND="
dev-libs/libxml2
net-misc/curl
sys-fs/fuse
dev-libs/openssl
"
RDEPEND="${DEPEND}"
