EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="mixlib-config.gemspec"

inherit ruby-fakegem

DESCRIPTION="Mixlib::Config provides a class-based configuration object, as used in Chef"
HOMEPAGE="https://github.com/chef/mixlib-config"
SRC_URI="https://github.com/chef/mixlib-config/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+="dev-ruby/tomlrb"
