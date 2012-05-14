# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rspec-expectations/rspec-expectations-2.6.0-r1.ebuild,v 1.2 2011/12/31 18:17:06 grobian Exp $

EAPI=2
USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="http://rspec.rubyforge.org/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/diff-lcs-1.1.2"

ruby_add_bdepend "test? (
		>=dev-ruby/rspec-core-2.4.0:2
		dev-ruby/rspec-mocks:2
	)"

ruby_add_bdepend "doc? ( dev-ruby/rspec-core:2 )"

# Not clear yet to what extend we need those (now)
#	>=dev-ruby/cucumber-0.6.2
#	>=dev-ruby/aruba-0.1.1"

each_ruby_test() {
	PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" ${RUBY} -S rake spec

	# There are features but they require aruba which we don't have yet.
}
