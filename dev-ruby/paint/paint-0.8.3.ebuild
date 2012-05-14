# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/childprocess/childprocess-0.3.0.ebuild,v 1.1 2012/01/14 08:06:06 graaff Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_GEMSPEC="paint.gemspec"

inherit ruby-fakegem

DESCRIPTION="Terminal painter"
HOMEPAGE="https://github.com/janlelis/paint"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""
