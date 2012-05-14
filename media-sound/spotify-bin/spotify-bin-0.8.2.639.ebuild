# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# From https://github.com/rjelierse/spotify-ebuilds/

EAPI=3

PSUM="g79d339d.504-1"

DESCRIPTION="Spotify desktop client"
HOMEPAGE="http://www.spotify.com/"
SRC_URI="
amd64? ( 
	http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${PV}.${PSUM}_amd64.deb 
)
x86?   (
	http://repository.spotify.com/pool/non-free/s/spotify/spotify-client_${PV}.${PSUM}_i386.deb
)"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+ffmpeg"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
	>=media-libs/alsa-lib-1.0.14
	>=sys-libs/glibc-2.6
	>=x11-libs/qt-core-4.5.0
	>=x11-libs/qt-gui-4.5.0[dbus]
	>=x11-libs/qt-webkit-4.5.0
	>=x11-libs/qt-dbus-4.5.0
	>=sys-devel/gcc-4.0.0[cxx]
	dev-libs/openssl
	dev-libs/nss
	dev-libs/nspr
	>=x11-libs/libXScrnSaver-1.2.0
	sys-apps/usbutils
	media-libs/libpng:1.2
	ffmpeg? ( media-video/ffmpeg )
"

OPENSSL_VERSION_CONFLICT=1
OPENSSL_SYMLINKS_CREATED=0

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	rm -f control.tar.gz data.tar.gz debian-binary
}

src_install() {
	cp -pPR * "${D}"/ || die

	# Create symbolic links for dev-libs/nss libraries
	dosym libnss3.so /usr/lib/libnss3.so.1d
	dosym libnssutil3.so /usr/lib/libnssutil3.so.1d
	dosym libsmime3.so /usr/lib/libsmime3.so.1d

	# Create symbolic links for dev-libs/nspr libraries
	dosym libplc4.so /usr/lib/libplc4.so.0d
	dosym libnspr4.so /usr/lib/libnspr4.so.0d

	# If we have a slotted install of dev-libs/openssl:0.9.8 and
	# an install of >=dev-libs/openssl-1, conflicts will arise.
	# If just >=dev-libs/openssl-1 is installed, we need to create
	# symlinks for spotify to function correctly.
	if has_version "<dev-libs/openssl-1"; then
		OPENSSL_VERSION_CONFLICT=0
	elif has_version ">=dev-libs/openssl-1"; then
		OPENSSL_VERSION_CONFLICT=0
		OPENSSL_SYMLINKS_CREATED=1
		dosym libssl.so.1.0.0 /usr/lib/libssl.so.0.9.8
		dosym libcrypto.so.1.0.0 /usr/lib/libcrypto.so.0.9.8
	fi
}

pkg_postinst() {
	if [[ $OPENSSL_VERSION_CONFLICT -eq 1 ]]; then
		ewarn "Multiple versions of dev-libs/openssl were detected on your"
		ewarn "system. This could result in crashes of Spotify when"
		ewarn "dependencies are linked against a different version of"
		ewarn "libopenssl than the spotify binary."
	elif [[ $OPENSSL_SYMLINKS_CREATED -eq 1 ]]; then
		elog "This package has created the following symlinks:"
		elog "  /usr/lib/libssl.so.0.9.8"
		elog "  /usr/lib/libcrypto.so.0.9.8"
		elog "Spotify requires these libraries, but we cannot use the"
		elog "slotted package that provides them because it will break"
		elog "the spotify binary."
	fi
}
