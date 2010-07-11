# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The gcovr script applies the Unix gcov command and generate a simple report that summarizes the coverage."
HOMEPAGE="https://software.sandia.gov/trac/fast/wiki/Documentation/gcovr"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="http://software.sandia.gov/trac/fast/export/2414/fast/trunk/scripts/gcovr"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin ${DISTDIR}/gcovr || die "Failed to install gcovr"
}
