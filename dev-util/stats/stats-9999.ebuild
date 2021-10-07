EAPI=7

EGIT_REPO_URI="https://github.com/rustyrussell/stats.git"

inherit git-r3 eutils

DESCRIPTION="simple filter to gather numbers in repeated text"
HOMEPAGE="https://github.com/rustyrussell/stats"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	emake config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" install
}
