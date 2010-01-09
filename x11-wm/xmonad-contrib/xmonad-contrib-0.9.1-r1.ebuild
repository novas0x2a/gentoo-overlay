# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"
CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal eutils

DESCRIPTION="Third party extensions for xmonad"
HOMEPAGE="http://xmonad.org/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xft"

RDEPEND=">=dev-lang/ghc-6.6.1
		dev-haskell/mtl
		>=dev-haskell/x11-1.5
		dev-haskell/utf8-string
		xft? ( >=dev-haskell/x11-xft-0.2 )
		~x11-wm/xmonad-${PV}"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2.1"

src_unpack() {
	default_src_unpack
}
src_prepare() {
	epatch "${FILESDIR}"/${PV}-*.patch
}

src_compile() {
	CABAL_CONFIGURE_FLAGS="--flags=-testing"

	if use xft; then
		CABAL_CONFIGURE_FLAGS="${CABAL_CONFIGURE_FLAGS} --flags=use_xft"
	else
		CABAL_CONFIGURE_FLAGS="${CABAL_CONFIGURE_FLAGS} --flags=-use_xft"
	fi

	cabal_src_compile
}
