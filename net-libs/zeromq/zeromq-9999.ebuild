# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils git

EGIT_REPO_URI="http://github.com/zeromq/zeromq2.git"
EGIT_BOOTSTRAP='./autogen.sh'

DESCRIPTION="ZeroMQ is a brokerless messaging kernel with extremely high performance."
HOMEPAGE="http://www.zeromq.org/"
SRC_URI=""
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pgm doc"

RDEPEND="
	dev-libs/openssl
"

DEPEND="${RDEPEND}
	doc? ( || ( app-text/asciidoc app-text/xmlto ) )
"

src_configure() {
	econf $(use_with pgm)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COPYING MAINTAINERS NEWS README || die "dodoc failed"
}
