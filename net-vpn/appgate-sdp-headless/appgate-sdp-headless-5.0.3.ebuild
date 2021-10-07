EAPI=7
inherit unpacker systemd

DESCRIPTION="marketing nonsense"
HOMEPAGE="https://www.appgate.com/software-defined-perimeter"

BASE=https://bin.appgate-sdp.com/5.0/client
FULL=appgate-sdp_5.0.3_amd64.deb
HEADLESS=appgate-sdp-headless_5.0.3_amd64.deb

SRC_URI="${BASE}/${FULL} ${BASE}/${HEADLESS}"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="
	acct-group/appgate
	acct-user/appgate
	app-arch/zstd
	app-crypt/mit-krb5
	dev-libs/gmp
	dev-libs/libtasn1
	dev-libs/libunistring
	dev-libs/nettle
	dev-libs/openssl
	dev-util/lttng-ust
	net-dns/dnsmasq
	net-dns/libidn2
	net-libs/gnutls
	net-libs/libssh2
	net-libs/nghttp2
	net-misc/curl
	sys-apps/keyutils
	sys-libs/e2fsprogs-libs
"

S=${WORKDIR}/headless

QA_PREBUILT="
	/opt/appgate/service/System.Globalization.Native.so
	/opt/appgate/service/System.IO.Compression.Native.so
	/opt/appgate/service/System.Native.so
	/opt/appgate/service/System.Net.Http.Native.so
	/opt/appgate/service/System.Net.Security.Native.so
	/opt/appgate/service/System.Security.Cryptography.Native.OpenSsl.so
	/opt/appgate/service/createdump
	/opt/appgate/service/libMonoPosixHelper.so
	/opt/appgate/service/libclrjit.so
	/opt/appgate/service/libcoreclr.so
	/opt/appgate/service/libcoreclrtraceptprovider.so
	/opt/appgate/service/libcredentialstorage.so
	/opt/appgate/service/libdbgshim.so
	/opt/appgate/service/libhostfxr.so
	/opt/appgate/service/libhostpolicy.so
	/opt/appgate/service/libmscordaccore.so
	/opt/appgate/service/libmscordbi.so
	/opt/appgate/service/libshim.so
	/opt/appgate/service/libsos.so
	/opt/appgate/service/libsosplugin.so
	/opt/appgate/tun-service
"

src_unpack() {
	mkdir headless full
	( cd headless && unpacker ${HEADLESS} )
	( cd full && unpacker ${FULL} )
}

src_install() {
	gunzip usr/share/doc/appgate-headless/changelog.gz || die
	gunzip usr/share/man/man5/appgate.conf.5.gz || die

	dodoc usr/share/doc/appgate-headless/changelog
	doman usr/share/man/man5/appgate.conf.5

	systemd_dounit lib/systemd/system/*

	insinto /opt
	cp -a opt/appgate "${ED}"/opt || die "cp failed"
	cp -a ../full/opt/appgate/service/libcredentialstorage.so "${ED}"/opt/appgate/service || die "cp failed"

	dosbin usr/sbin/appgate_service_configurator

	insinto /usr/share/dbus-1/services
	doins usr/share/dbus-1/system-services/com.appgate.resolver.service

	insinto /etc
	doins etc/appgate.conf

	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/system.d/appgate.conf
}
