# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18 ruby19"

RUBY_S="citrusbyte-${PN}-*"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC=""
RUBY_FAKEGEM_GEMSPEC="contest.gemspec"
RUBY_FAKEGEM_EXTRAINSTALL=""

inherit ruby-fakegem

DESCRIPTION="Write more readable tests in Test::Unit with this tiny script."
HOMEPAGE="https://github.com/citrusbyte/contest"
SRC_URI="https://github.com/citrusbyte/contest/tarball/master -> contest-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
