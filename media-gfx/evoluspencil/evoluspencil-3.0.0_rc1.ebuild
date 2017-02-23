EAPI="6"

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit eutils unpacker chromium-2 gnome2-utils xdg-utils

DESCRIPTION="The Pencil Project's unique mission is to build a free and opensource tool for making diagrams and GUI prototyping that everyone can use."
HOMEPAGE="http://pencil.evolus.vn"

MY_PN="Pencil"
MY_PV="${PV/_rc/-rc.}"
MY_P="${MY_PN}-${MY_PV}"

SRC_URI="https://github.com/evolus/pencil/releases/download/v${MY_PV}/${MY_P}.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND=""

QA_PREBUILT="*"
S=${WORKDIR}
CHROME_HOME="opt/Pencil"

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "${PN} only works on amd64"
}

src_install() {
	mv usr/share/doc/pencil usr/share/doc/${PF} || die

	pushd "${CHROME_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	insinto /
	doins -r opt usr
	dosym "/${CHROME_HOME}/${MY_PN}" "/usr/bin/${MY_PN}"
	chmod 755 "${ED}${CHROME_HOME}"/${MY_PN} || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
