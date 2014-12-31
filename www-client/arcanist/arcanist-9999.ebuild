# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses"

inherit bash-completion-r1 python-single-r1 git-r3

DESCRIPTION="Command-line tool for Phabricator"
HOMEPAGE="http://www.phabricator.org"
EGIT_REPO_URI="git://github.com/phacility/arcanist.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="css git javascript mercurial php python ruby subversion ssl test"
REQUIRED_USE="test? ( css git javascript php python ruby )"

DEPEND="virtual/awk:0
	test? (
		>=dev-lang/php-5.2.3[xmlwriter]
		=dev-php/libphutil-${PV}:0[test]
		dev-util/cpplint:0
	)"
RDEPEND=">=dev-lang/php-5.2.3[cli,curl,json,ssl?]
	=dev-php/libphutil-${PV}:0[ssl?]
	git? ( dev-vcs/git:0 )
	mercurial? ( dev-vcs/mercurial:0 )
	subversion? ( dev-vcs/subversion:0 )
	css? ( net-libs/nodejs:0[npm] )
	javascript? ( net-libs/nodejs:0[npm] )
	php? ( dev-php/PEAR-PHP_CodeSniffer:0 )
	python? (
		dev-python/pylint:0[${PYTHON_USEDEP}]
		dev-python/flake8:0[${PYTHON_USEDEP}]
	)
	ruby? ( dev-lang/ruby )"

src_test() {
	# TODO s/ewarn/die until https://github.com/facebook/arcanist/issues/99
	bin/arc unit --everything --no-coverage || ewarn "arc unit failed"
}

src_prepare() {
	echo "${EGIT_VERSION}" > "${S}/VERSION"

	find "${S}" -type f -name .gitignore -print0 \
		| xargs -0 --no-run-if-empty -- \
			rm

	# Provided by dev-python/pep8
	rm -r externals/pep8

	rm bin/*.bat

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

src_install() {
	newbashcomp resources/shell/bash-completion "${PN}"

	insinto "/usr/share/${PN}"
	doins VERSION

	insinto "/usr/share/php/${PN}"
	doins -r bin externals resources scripts src

	python_scriptinto "/usr/share/php/${PN}/scripts"
	python_doscript scripts/breakout.py

	# Make executable all shebanged files
	find "${ED}" -type f \
		| xargs -n 1 --no-run-if-empty -- \
			awk 'NR == 1 && /^#!/ {print FILENAME}' \
		| sed -e "s:${ED}:/:" \
		| xargs --no-run-if-empty -- \
			fperms 755

	dosym "/usr/share/php/${PN}/bin/arc" /usr/bin/arc

	dodoc NOTICE README
}

pkg_postinst() {
	elog
	elog "Linter for different languages are available thrue USE flags"
	elog "  css javascript php python ruby"

	if use css ; then
		elog
		elog "To enable javascript linter, you need to manually install CSS lint"
		elog "	npm install csslint -g"
	fi

	if use javascript ; then
		elog
		elog "To enable javascript linter, you need to manually install JSHint"
		elog "	npm install jshint -g"
	fi
}
