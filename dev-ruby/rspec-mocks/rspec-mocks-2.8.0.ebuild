# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rspec-mocks/rspec-mocks-2.6.0-r1.ebuild,v 1.2 2011/12/31 18:15:57 grobian Exp $

EAPI=2
USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_TASK_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="http://rspec.rubyforge.org/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# cucumber and rspec-core are loaded unconditionally in the Rakefile,
# so we also need to require them for USE=doc.
ruby_add_bdepend "test? (
		>=dev-ruby/rspec-core-2.6.0:2
		dev-ruby/rspec-expectations:2
	)
	doc? ( dev-ruby/rspec-core:2 )"

# Not clear yet to what extend we need those (now)
#	>=dev-ruby/cucumber-0.6.2
#	>=dev-ruby/aruba-0.1.1"

all_ruby_compile() {
	if use doc ; then
		RUBYLIB="${S}/lib" rake rdoc || die
	fi
}

each_ruby_test() {
	case ${RUBY} in
		*jruby)
			# This particular failure is reported to be fixed in jruby 1.6.
			ewarn "Tests disabled because they crash jruby."
			;;
		*)
			PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" ${RUBY} -S rake spec || die
			;;
	esac

	# There are features but they require aruba which we don't have yet.
}
