# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18"
RUBY_FAKEGEM_EXTRADOC="README"

inherit git ruby-ng ruby-fakegem

EGIT_REPO_URI="http://github.com/progrium/localtunnel.git"

DESCRIPTION="instant public tunnel for local web servers"
HOMEPAGE="http://github.com/progrium/localtunnel"
SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_bdepend "
	dev-ruby/rake
	dev-ruby/echoe
"
ruby_add_rdepend "
	dev-ruby/rake
	>=dev-ruby/json-1.2.4
	>=dev-ruby/net-ssh-2.0.22
	>=dev-ruby/net-ssh-gateway-1.0.1
"

all_ruby_unpack() {
	git_src_unpack
}

each_ruby_compile() {
	${RUBY} -S rake gem || die "gem build failed"
}
