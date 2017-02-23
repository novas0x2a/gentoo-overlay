# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

GOLANG_PKG_IMPORTPATH="golang.org/x/tools/cmd"
GOLANG_PKG_VERSION="v.${PV//.}"
GOLANG_PKG_HAVE_TEST=1

inherit golang-live

DESCRIPTION="Syntactic and semantic analysis of Go files and packages."
HOMEPAGE="https://github.com/nsf/gocode"
HOMEPAGE="https://godoc.org/golang.org/x/tools/cmd/gotype"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-fbsd ~x86-fbsd"
