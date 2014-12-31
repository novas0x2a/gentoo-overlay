# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils toolchain-funcs git-r3

DESCRIPTION="Collection of utility classes and functions for PHP used by phabricator"
HOMEPAGE="http://www.phabricator.org"
EGIT_REPO_URI="git://github.com/phacility/libphutil.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="ssl test"

DEPEND="virtual/awk:0
	test? (
		sys-devel/bison:0
		>=sys-devel/flex-2.5.35:0
		=www-client/arcanist-${PV}:0
		dev-lang/php[cli]
	)"
RDEPEND=">=dev-lang/php-5.2.3[curl,iconv,json,mysql,mysqli,pcntl,ssl?,unicode]
	dev-php/pecl-apcu:0"

src_prepare() {
	epatch "${FILESDIR}/${PV}-Remove-the-usage-of-local-SSL-certificates-and-use-s.patch"

	echo "${EGIT_VERSION}" > "${S}/VERSION"

	if use test ; then
		tc-export AR CXX
	fi

	find "${S}" -type f -name .gitignore -print0 \
		| xargs -0 --no-run-if-empty -- \
			rm

	rm -r resources/ssl
	rm -r scripts/daemon/torture
	rm scripts/build_xhpast.sh
	rm src/parser/xhpast/bin/xhpast.exe

	# Replace 'env' shebang to files it point to
	find "${S}" -type f \
		| sort \
		| xargs -n 1 --no-run-if-empty -- \
			awk 'NR == 1 && /^#!\/usr\/bin\/env/ {print FILENAME}' \
		| while read ; do
			set -- $(sed -ne '1 s:^#!\([^ ]*\) ::p;q' ${REPLY})
			cmd="$1" ; shift ; args="$@"

			case "${cmd}" in
				bash|php)	;;
				*)			continue ;;
			esac

			path="$(type -p ${cmd})" || continue
			[[ -z "${path}" ]] && continue

			einfo "Changing ${REPLY/#${S}\/} shebang to #!${path} ${args}"
			sed -i \
				-e "1 s:^#!.*:#!${path} ${args}:" \
				"${REPLY}"
			eend $?
		done
}

src_compile() {
	if use test ; then
		cd support/xhpast

		# Avoid sandbox violation for dev-lang/php[snmp]
		# php -f generate_nodes.php'
		#
		#  * ACCESS DENIED:  open_wr:      /var/lib/net-snmp/mib_indexes/0
		#  abs_path: /var/lib/net-snmp/mib_indexes/0
		#  res_path: /var/lib/net-snmp/mib_indexes/0
		#  /usr/lib64/libsandbox.so(+0xd9d1)[0x7f226c8899d1]
		#  /usr/lib64/libsandbox.so(+0xdaf8)[0x7f226c889af8]
		#  /usr/lib64/libsandbox.so(+0x59cf)[0x7f226c8819cf]
		#  /usr/lib64/libsandbox.so(fopen+0x7c)[0x7f226c8843ec]
		#  /usr/lib64/libnetsnmp.so.30(netsnmp_mibindex_new+0x48)[0x7f22695f55e8]
		#  /usr/lib64/libnetsnmp.so.30(add_mibdir+0x9c)[0x7f226960a00c]
		#  /usr/lib64/libnetsnmp.so.30(netsnmp_init_mib+0xca)[0x7f22695f4bea]
		#  /usr/lib64/libnetsnmp.so.30(init_snmp+0x32d)[0x7f226961c2dd]
		#  php(zm_startup_snmp+0x51)[0x7f226cf81e11]
		#  php(zend_startup_module_ex+0x11a)[0x7f226d0bccea]
		#  /proc/15834/cmdline: php -f generate_nodes.php
		#
		# See snmp_config(5)
		export SNMP_PERSISTENT_DIR="${T}"

		emake
		emake install
	fi
}

src_test() {
	arc unit --everything --no-coverage || die "arc unit failed"
}

src_install() {
	insinto "/usr/share/${PN}"
	doins VERSION

	insinto "/usr/share/php/${PN}"
	doins -r externals resources scripts src

	if use test ; then
		fperms 755 "/usr/share/php/${PN}/src/parser/xhpast/bin/xhpast"
		dosym "/usr/share/php/${PN}/src/parser/xhpast/bin/xhpast" /usr/bin/xhpast
	fi

	# Make executable all shebanged files
	find "${ED}" -type f \
		| xargs -n 1 --no-run-if-empty -- \
			awk 'NR == 1 && /^#!/ {print FILENAME}' \
		| sed -e "s:${ED}:/:" \
		| xargs --no-run-if-empty -- \
			fperms 755

	dodoc NOTICE README
}
