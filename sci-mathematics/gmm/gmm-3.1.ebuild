# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/gmm/gmm-3.0.ebuild,v 1.5 2009/07/01 15:05:10 aballier Exp $

inherit eutils

DESCRIPTION="generic C++ template library for sparse, dense and skyline matrices"
SRC_URI="http://download.gna.org/getfem/stable/${P}.tar.gz"
HOMEPAGE="http://www-gmm.insa-toulouse.fr/getfem/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS INSTALL README NEWS
}
