EAPI=5

EGIT_REPO_URI="https://github.com/rustyrussell/stats.git"

inherit git-2 eutils

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
