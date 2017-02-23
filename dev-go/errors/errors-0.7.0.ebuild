# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN=errors
GOLANG_PKG_IMPORTPATH=github.com/pkg

inherit golang-build

DESCRIPTION="Simple error handling primitives"
HOMEPAGE="https://github.com/pkg/errors"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
