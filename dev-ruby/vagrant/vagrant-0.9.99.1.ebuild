# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

RUBY_S="mitchellh-${PN}-*"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="vagrant.gemspec"
RUBY_FAKEGEM_EXTRAINSTALL="keys config templates"

inherit ruby-fakegem

TAG_VERSION=${PV/0.9.99./1.0.0.rc}

DESCRIPTION="Build and distribute virtualized development environments."
HOMEPAGE="http://vagrantup.com"
SRC_URI="https://github.com/mitchellh/vagrant/tarball/v${TAG_VERSION} -> vagrant-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="develop"

ruby_add_rdepend "
>=dev-ruby/archive-tar-minitar-0.5.2-r3
>=dev-ruby/childprocess-0.3.1
>=dev-ruby/erubis-2.7.0
>=dev-ruby/i18n-0.6.0
>=dev-ruby/json-1.5.1
>=dev-ruby/log4r-1.1.9
>=dev-ruby/net-scp-1.0.4
>=dev-ruby/net-ssh-2.2.2
"

ruby_add_rdepend develop "
  dev-ruby/rake
  dev-ruby/bundler
  >=dev-ruby/contest-0.1.2
  >=dev-ruby/minitest-2.5.1
  dev-ruby/mocha
  >=dev-ruby/rspec-core-2.8.0
  >=dev-ruby/rspec-expectations-2.8.0
  >=dev-ruby/rspec-mocks-2.8.0
"
