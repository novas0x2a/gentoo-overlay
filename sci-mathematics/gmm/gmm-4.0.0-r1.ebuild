# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/gmm/gmm-4.0.0.ebuild,v 1.1 2010/01/14 16:29:15 bicatali Exp $

EAPI=2

DESCRIPTION="Generic C++ template library for sparse, dense and skyline matrices"
SRC_URI="http://download.gna.org/getfem/stable/${P}.tar.gz"
HOMEPAGE="http://www-gmm.insa-toulouse.fr/getfem/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

src_prepare() {
	sed -i -e 's/NAMESPACE::mem_usage_t/::mem_usage_t/' \
		include/gmm/gmm_superlu_interface.h

	# WTF. They're relying on vector<int> degrading to int*
	sed -i -e 's/(int \*)(csc_A.ir)/(int *)\&csc_A.ir[0]/' \
		   -e 's/(int \*)(csc_A.jc)/(int *)\&csc_A.jc[0]/' \
		   -e 's/csc_A.pr/\&&[0]/' 					\
		include/gmm/gmm_superlu_interface.h

}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS
}
