# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils distutils git

EGIT_REPO_URI="http://github.com/zeromq/pyzmq.git"

DESCRIPTION="ZeroMQ is a brokerless messaging kernel with extremely high performance. (python version)"
HOMEPAGE="http://www.zeromq.org/"
SRC_URI=""
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-libs/openssl
	=net-libs/zeromq-9999
"

DEPEND="${RDEPEND}
	doc? ( || ( app-text/asciidoc app-text/xmlto ) )
"

src_prepare() {
	echo <<EOL > ${WORKDIR}/setup.cfg
[build_ext]
library_dirs = /usr/lib
include_dirs = /usr/include
EOL
}
