# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
CABAL_FEATURES="lib profile haddock"

inherit haskell-cabal eutils darcs

DESCRIPTION="Third party extensions for xmonad"
HOMEPAGE="http://xmonad.org/"
EDARCS_REPOSITORY="http://code.haskell.org/XMonadContrib"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="xft unicode"

DEPEND=">=dev-lang/ghc-6.6.1
		>=dev-haskell/mtl-1.0
		dev-haskell/x11-darcs
		>=dev-haskell/cabal-1.2.1
		unicode? ( >=dev-haskell/utf8-string-0.3.3 )
		xft? ( >=dev-haskell/utf8-string-0.3.3
			   >=dev-haskell/x11-xft-0.3 )
		x11-wm/xmonad-darcs"

RDEPEND="${DEPEND}"

src_unpack() {
	darcs_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/*.patch
}

src_compile() {
	if use xft; then
		CABAL_CONFIGURE_FLAGS="${CABAL_CONFIGURE_FLAGS} --flags=use_xft"
	else
		CABAL_CONFIGURE_FLAGS="${CABAL_CONFIGURE_FLAGS} --flags=-use_xft"
	fi

	if use unicode; then
		CABAL_CONFIGURE_FLAGS="$CABAL_CONFIGURE_FLAGS --flags=with_utf8"
	else
		CABAL_CONFIGURE_FLAGS="$CABAL_CONFIGURE_FLAGS --flags=-with_utf8"
	fi
	cabal_src_compile
}
