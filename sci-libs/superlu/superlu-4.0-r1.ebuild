# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils toolchain-funcs

MY_PN=SuperLU

DESCRIPTION="Sparse LU factorization library"
HOMEPAGE="http://crd.lbl.gov/~xiaoye/SuperLU/"
SRC_URI="${HOMEPAGE}/${PN}_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	test? ( app-shells/tcsh )"

S="${WORKDIR}/${MY_PN}_${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	epatch "${FILESDIR}"/${PN}-examples.patch
	epatch "${FILESDIR}"/${P}-makeinc.patch
	#epatch "${FILESDIR}"/0001-slu_util-should-not-be-protected-against-multiple-in.patch

	eautoreconf
}

src_configure() {
	econf \
		--with-blas="$(pkg-config --libs blas)"
}

src_test() {
	cd TESTING/MATGEN
	emake \
		CC=$(tc-getCC) \
		|| die "emake matrix generation failed"
	cd ..
	emake \
		CC=$(tc-getCC) \
		SUPERLULIB=../SRC/.libs/libsuperlu.a \
		BLASLIB="$(pkg-config --libs blas)" \
		|| die "emake test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto /usr/include/superlu
	doins SRC/*.h || die "Could not install headers!"
	dodoc README  || die "Could not install README"

	use doc && newdoc INSTALL/ug.ps userguide.ps
	if use examples; then
		insinto /usr/share/doc/${PF}
		newins -r EXAMPLE examples
	fi
}
