# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/wirble/wirble-0.1.3-r3.ebuild,v 1.2 2014/08/05 16:01:01 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md Changelog.md"

inherit ruby-fakegem

DESCRIPTION="Minimalist, opinionated client to manage your Pivotal Tracker tasks from the command line."
HOMEPAGE="https://github.com/raul/pt"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/pivotal-tracker-0.4.1
	>=dev-ruby/hirb-0.4.5
	dev-ruby/colored
	>=dev-ruby/highline-1.6.1
"
