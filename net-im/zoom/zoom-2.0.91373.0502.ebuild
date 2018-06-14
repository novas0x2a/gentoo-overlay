# Intended to be net-im/zoom-${PV}

EAPI=5
inherit eutils xdg

DESCRIPTION="A client for Zoom's meeting/teleconference system"
HOMEPAGE="https://zoom.us/"

# Uses the arch package link because that's already organized
SRC_URI="
	amd64? ( https://zoom.us/client/${PV}/zoom_x86_64.pkg.tar.xz -> zoom-${PV}.tar.xz )
"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="strip preserve-libs mirror"

DEPEND=""
RDEPEND=""

QA_PREBUILT="*"
S=${WORKDIR}

src_prepare() {
	sed -i \
		-e 's/Icon=Zoom.png/Icon=Zoom/' \
		-e 's/\(Categories=.*\)Application;/\1/' \
	usr/share/applications/Zoom.desktop
}

src_install() {
	dodoc usr/share/doc/zoom/changelog.Debian.gz
	rm -f usr/share/doc/zoom/changelog.Debian.gz

	doins -r opt
	doins -r usr

	fperms 0755 /opt/zoom/{zoom,ZoomLauncher,zoomlinux,zopen,*.sh}

	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=/opt/zoom" >> ${T}/10${PN}
	doins "${T}"/10${PN} || die
}
