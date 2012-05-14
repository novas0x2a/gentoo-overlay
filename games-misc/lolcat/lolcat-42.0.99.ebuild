# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#!/bin/bash

EAPI=4
USE_RUBY="ruby18"

RUBY_S="busyloop-${PN}-*"

RUBY_FAKEGEM_GEMSPEC="lolcat.gemspec"

inherit ruby-fakegem

DESCRIPTION="Meow"
HOMEPAGE="https://github.com/busyloop/lolcat"
SRC_URI="https://github.com/busyloop/lolcat/tarball/v42.0.99 -> ${P}.tar"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ruby/paint dev-ruby/trollop"
RDEPEND="${DEPEND}"
DOCS="doc/*"
