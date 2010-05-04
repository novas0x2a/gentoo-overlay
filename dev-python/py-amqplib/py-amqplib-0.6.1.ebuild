# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rpy/rpy-2.0.8.ebuild,v 1.2 2009/12/21 03:37:08 arfrever Exp $

EAPI="2"

inherit distutils eutils

MYPN=${PN/py-/}

DESCRIPTION="Python interface to amqplib"
HOMEPAGE="http://code.google.com/p/py-amqplib/"
SRC_URI="http://py-amqplib.googlecode.com/files/amqplib-${PV}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

PYTHON_MODNAME="${MYPN}"
S="${WORKDIR}/${MYPN}-${PV}"
