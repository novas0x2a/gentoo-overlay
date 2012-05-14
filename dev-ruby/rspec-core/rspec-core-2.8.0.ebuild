# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rspec-core/rspec-core-2.6.4-r1.ebuild,v 1.2 2011/12/31 18:24:21 grobian Exp $

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

RDEPEND="${RDEPEND} !<dev-ruby/rspec-1.3.1-r1"

ruby_add_bdepend "test? (
		dev-ruby/nokogiri
		dev-ruby/syntax
		>=dev-ruby/zentest-4.4.1
		dev-ruby/rspec-expectations:2
		dev-ruby/rspec-mocks:2
	)"

#	>=dev-ruby/cucumber-0.5.3
#	>=dev-ruby/autotest-4.2.9 -> zentest-4.4.1
#	dev-ruby/aruba"

all_ruby_prepare() {
	# Also clean the /usr/lib/rubyee path (which is our own invention).
	sed -i -e 's#lib\\d\*\\/ruby\\/#lib\\d*\\/ruby(ee|)\\/#' lib/rspec/core/configuration.rb || die

	# Remove jruby-specific comparison documents since for us the normal
	# version passes.
	cp spec/rspec/core/formatters/html_formatted-1.8.7.html spec/rspec/core/formatters/html_formatted-1.8.7-jruby.html|| die
	cp spec/rspec/core/formatters/text_mate_formatted-1.8.7.html spec/rspec/core/formatters/text_mate_formatted-1.8.7-jruby.html|| die
}

all_ruby_compile() {
	if use doc ; then
		RUBYLIB="${S}/lib" rake rdoc || die "Unable to create documentation."
	fi
}

each_ruby_test() {
	case ${RUBY} in
		*jruby)
			# Run jruby's tests with the installed rspec script since
			# otherwise files can't be found for some unknown reason.
			RUBYLIB=${S}/lib ${RUBY} -S rspec --color spec || die "Tests failed."
			;;
		*)
			PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" ${RUBY} -S rake spec || die "Tests failed."
			;;
	esac

	# There are features but it seems as if these only work against a
	# fully installed version.
}
