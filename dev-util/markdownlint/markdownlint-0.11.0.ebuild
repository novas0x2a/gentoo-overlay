EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="mdl.gemspec"

inherit ruby-fakegem

DESCRIPTION="A tool to check markdown files and flag style issues"
HOMEPAGE="https://github.com/markdownlint/markdownlint"
SRC_URI="https://github.com/markdownlint/markdownlint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+="
	>=dev-ruby/kramdown-2.3.0
	>=dev-ruby/kramdown-parser-gfm-1.1.0
	dev-ruby/mixlib-shellout
	>=dev-ruby/mixlib-cli-2.1.1
	>=dev-ruby/mixlib-config-2.2.1
	<dev-ruby/mixlib-config-4.0.0
"
