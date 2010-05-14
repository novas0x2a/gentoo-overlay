# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/xulrunner/xulrunner-1.9.1.3.ebuild,v 1.3 2009/09/15 02:15:25 anarchy Exp $
EAPI="2"
WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils mozconfig-3 makeedit multilib pax-utils subversion autotools mozextension

XUL_PV="1.9.1.3"
MAJ_XUL_PV="1.9.1"
FF_PV="3.5.3"

ESVN_REPO_URI="http://svn.mozilla.org/projects/webrunner/trunk"
ESVN_PROJECT="prism"

DESCRIPTION="SSB Browser Builder"
HOMEPAGE="http://developer.mozilla.org/en/docs/XULRunner"
REL_URI="http://releases.mozilla.org/pub/mozilla.org/firefox/releases"
SRC_URI="${REL_URI}/${FF_PV}/source/firefox-${FF_PV}.source.tar.bz2"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 -sparc ~x86"
SLOT="0"
LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
IUSE="+alsa mozdevelop debug" # qt-experimental

# Not working.
#	qt-experimental? (
#		x11-libs/qt-gui
#		x11-libs/qt-core )
#	=net-libs/xulrunner-${XUL_PV}*[java=,qt-experimental=]

RDEPEND="
	>=sys-devel/binutils-2.16.1
	>=dev-libs/nss-3.12.3
	>=dev-libs/nspr-4.8
	>=app-text/hunspell-1.2
	alsa? ( media-libs/alsa-lib )
	>=net-libs/xulrunner-${XUL_PV}[java=]
	>=media-libs/lcms-1.17
	>=x11-libs/cairo-1.8.8[X]
	x11-libs/pango[X]
	x11-libs/libXt"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/mozilla-${MAJ_XUL_PV}"
# Needed by src_compile() and src_install().
# Would do in pkg_setup but that loses the export attribute, they
# become pure shell variables.
export BUILD_OFFICIAL=1
export MOZILLA_OFFICIAL=1

src_unpack() {
	unpack ${A}
	cd "${S}"
	subversion_fetch ${ESVN_REPO_URI} prism || die "${ESVN}: unknown problem occurred in subversion_fetch."
}

src_prepare() {
	# Apply our patches
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}"

	eautoreconf

	cd js/src
	eautoreconf

	# We need to re-patch this because autoreconf overwrites it
	epatch "${FILESDIR}/000_flex-configure-LANG.patch"
}

src_configure() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	MEXTENSIONS="default"

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	mozconfig_config

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"
	mozconfig_annotate '' --enable-application=prism
	mozconfig_annotate '' --disable-mailnews
	mozconfig_annotate 'broken' --disable-crashreporter
	mozconfig_annotate '' --enable-image-encoder=all
	mozconfig_annotate '' --enable-canvas
	# Bug 60668: Galeon doesn't build without oji enabled, so enable it
	# regardless of java setting.
	mozconfig_annotate '' --enable-oji --enable-mathml
	mozconfig_annotate 'places' --enable-storage --enable-places
	mozconfig_annotate '' --enable-safe-browsing

	# System-wide install specs
	mozconfig_annotate '' --disable-installer
	mozconfig_annotate '' --disable-updater
	mozconfig_annotate '' --disable-strip
	mozconfig_annotate '' --disable-install-strip

	# Use system libraries
	mozconfig_annotate '' --enable-system-cairo
	mozconfig_annotate '' --enable-system-hunspell
	# mozconfig_annotate '' --enable-system-sqlite
	mozconfig_annotate '' --with-system-nspr
	mozconfig_annotate '' --with-system-nss
	mozconfig_annotate '' --enable-system-lcms
	mozconfig_annotate '' --with-system-bz2
	mozconfig_annotate '' --with-system-libxul
	mozconfig_annotate '' --with-libxul-sdk=/usr/$(get_libdir)/xulrunner-devel-${MAJ_XUL_PV}

	# IUSE mozdevelop
	mozconfig_use_enable mozdevelop jsd
	mozconfig_use_enable mozdevelop xpctools
	#mozconfig_use_extension mozdevelop venkman

	# IUSE qt-experimental
#	if use qt-experimental ; then
#		ewarn "You are enabling the EXPERIMENTAL qt toolkit"
#		ewarn "Usage is at your own risk"
#		ewarn "Known to be broken. DO NOT file bugs."
#		mozconfig_annotate '' --disable-system-cairo
#		mozconfig_annotate 'qt-experimental' --enable-default-toolkit=cairo-qt
#	else
		mozconfig_annotate 'gtk' --enable-default-toolkit=cairo-gtk2
#	fi

	# Other ff-specific settings
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}

	# Enable/Disable audio in firefox
	mozconfig_use_enable alsa ogg
	mozconfig_use_enable alsa wave

	# Finalize and report settings
	mozconfig_final

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	####################################
	#
	#  Configure and build
	#
	####################################

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" econf
}

src_compile() {
	# Should the build use multiprocessing? Not enabled by default, as it tends to break
	[ "${WANT_MP}" = "true" ] && jobs=${MAKEOPTS} || jobs="-j1"
	emake ${jobs} || die
}

src_install() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	emake DESTDIR="${D}" install || die "emake install failed"
	rm "${D}"/usr/bin/prism

	# Create /usr/bin/prism
	cat <<EOF >"${D}"/usr/bin/prism
#!/bin/sh
export LD_LIBRARY_PATH="${MOZILLA_FIVE_HOME}\${LD_LIBRARY_PATH+":\${LD_LIBRARY_PATH}"}"
exec "${MOZILLA_FIVE_HOME}"/prism "\$@"
EOF

	fperms 0755 /usr/bin/prism
	pax-mark m "${D}"/${MOZILLA_FIVE_HOME}/prism

	# Plugins dir
	dosym ../nsbrowser/plugins "${MOZILLA_FIVE_HOME}"/plugins || die
}
