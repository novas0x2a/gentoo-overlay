# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN="github.com/direnv/direnv"

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Direnv is an environment switcher for the shell."
HOMEPAGE="http://direnv.net"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 arm"

DOCS=( docs/ruby.md )
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_install() {
	dobin "${PN}"
	doman "${S}"/man/*.1
}

src_test() {
	./test/direnv-test.sh || die
}
