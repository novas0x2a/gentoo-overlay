# Intended to be net-im/zoom-${PV}

EAPI=5
inherit eutils xdg

DESCRIPTION="A client for Zoom's meeting/teleconference system"
HOMEPAGE="https://zoom.us/"

# Uses the arch package link because that's already organized
SRC_URI="
	amd64? ( https://zoom.us/client/${PV}/zoom_x86_64.tar.xz -> zoom-${PV}.tar.xz )
"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="strip preserve-libs mirror"

DEPEND=""
RDEPEND=""

QA_PREBUILT="*"

S="${WORKDIR}/${PN}"

src_install() {
	insinto /opt
	doins -r "${S}"

	fperms 0755 /opt/zoom/{zoom,ZoomLauncher,zoomlinux,zopen,zoom.sh,qtdiag,QtWebEngineProcess}
	fperms 0755 $(find "${ED}" -name '*.so' -printf '/%P\n')

	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=/opt/zoom" >> ${T}/10${PN}
	doins "${T}"/10${PN} || die

	domenu "${FILESDIR}"/${PN}.desktop
	doicon "${S}"/{Zoom,application-x-zoom}.png

	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/${PN}.xml

	dosym /opt/zoom/zoomlinux /usr/bin/zoom
}
