# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit mercurial autotools

DESCRIPTION="A C implementation of the rabbitmq AMQP client"
HOMEPAGE="http://hg.rabbitmq.com/rabbitmq-c"
LICENSE="MPL-1.1"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
|| (
	>=dev-lang/python-2.6
	dev-python/simplejson
)"
RDEPEND=""

export EHG_REVISION="default"

S="${WORKDIR}/${PN}"

src_unpack() {
	mercurial_fetch "http://hg.rabbitmq.com/rabbitmq-c" || die "fetch failed"
	mercurial_fetch "http://hg.rabbitmq.com/rabbitmq-codegen" "rabbitmq-c/codegen" || die "fetch failed"
	cd "${S}"
	#sed -i -e 's/0.9.1/0.8/' configure.ac
	eautoreconf
}

src_compile() {
	emake PYTHON=python || die "emake failed"
}

src_install() {
	emake install DESTDIR=${D} || die "install failed"
}
