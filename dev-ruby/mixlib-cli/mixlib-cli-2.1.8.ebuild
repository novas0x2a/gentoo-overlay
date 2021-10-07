EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="mixlib-cli.gemspec"

inherit ruby-fakegem

DESCRIPTION="Mixlib::CLI provides a class-based command line option parsing object, like the one used in Chef, Ohai and Relish"
HOMEPAGE="https://github.com/chef/mixlib-cli"
SRC_URI="https://github.com/chef/mixlib-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
