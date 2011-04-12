# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs multilib eutils flag-o-matic

#KAKADU_LIST_CKSUM=11155ee97c2d7efa302f687419a6fe579f6277ce

KAKADU_MAJOR_VERSION=${PV%%.*}
KAKADU_POINT_VERSION=${PV##*.}
KAKADU_MINOR_VERSION=${PV%.*}
KAKADU_MINOR_VERSION=${KAKADU_MINOR_VERSION#*.}

KAKADU_OLD_SUFFIX=_v64R.so
KAKADU_NEW_SUFFIX=$(get_libname ${PV})

# using their libname (ie, v64R) as inspiration, derive SONAME
KAKADU_SONAME_VERSION=$(get_libname ${KAKADU_MAJOR_VERSION}.${KAKADU_MINOR_VERSION})


DESCRIPTION="A JPEG2000 encoder/decoder implementing much of the spec"
HOMEPAGE="http://www.kakadusoftware.com/"
LICENSE="kakadu-noncommercial"
SLOT="0"
SRC_URI="kakadu-${PV}.zip"
KEYWORDS="~x86 ~amd64"
IUSE="mmx sse sse2 sse3 +tools +threads debug doc"
RESTRICT="bindist fetch"

get_kdu_arch() {
	case ${CHOST} in
		x86_64-*-linux*) echo Linux-x86-64-gcc;;
		i686-*-linux*)   echo Linux-x86-32-gcc;;
		#*-darwin*)       echo MAC-x86-32-gcc;;
		*)               eerror "I don't know what your platform is";;
	esac
}

get_makefile_name() {
	echo "Makefile-$(get_kdu_arch)"
}

pkg_nofetch() {
	elog "You need to go to http://www.kakadusoftware.com/ and get a license."
	elog "After you download your zip, rename it to ${SRC_URI}"
	elog "and move it to ${DISTDIR}"
}

pkg_setup() {
	if use doc && ! use tools; then
		die "Must build tools to build docs"
	fi
}

src_unpack() {
	default_src_unpack
	## This will only protect against partial files... it won't protect against
	## intentional maliciousness.
	#local list_chksum="$(unzip -l ${SRC_URI} | cut -d / -f 2- | sha1sum | cut -d ' ' -f 1)"

	#if [[ ${list_chksum} != ${KAKADU_LIST_CKSUM} ]]; then
	#	die "Checksum failure [got ${list_chksum}]! Please rm ${SRC_URI} and try again!";
	#fi

	#unzip -qo "${SRC_URI}" \
	#	|| die "Could not unzip ${SRC_URI}"
	mv v* ${P} || die "Could not remove license id from kakadu directory name"
}

src_prepare() {
	epatch "${FILESDIR}"/6.4.1-0001-clean-up-the-apps-targets-a-bit.patch
	epatch "${FILESDIR}"/6.4.1-0002-build-a-kdu_apps-shared-library.patch

	local makefile=$(get_makefile_name)
	sed -i \
		-e "s/${KAKADU_OLD_SUFFIX}/${KAKADU_NEW_SUFFIX}/g" \
		-e 's/$(LIBS)/$(LDFLAGS) $(LIBS)/g' \
		-e 's/-shared/$(LDFLAGS) -shared $(LIBS)/g' \
		-e 's/ -lpthread//g' \
		coresys/make/${makefile} \
		apps/make/${makefile} \
			|| die "Failed to mangle makefiles"

	sed -i -e "s/-shared/-shared -Wl,-soname,libkdu${KAKADU_SONAME_VERSION}/g" \
		coresys/make/${makefile} || die "Failed to set SONAME on libkdu"
	sed -i -e "s/-shared/-shared -Wl,-soname,libkdu_apps${KAKADU_SONAME_VERSION}/g" \
		apps/make/${makefile} || die "Failed to set SONAME on libkdu_apps"
}

src_compile() {
	local makefile=$(get_makefile_name)
	local flags="-fPIC"

	if ! use debug; then
		flags="${flags} -DNDEBUG"
	fi

	if ! use threads; then
		flags="${flags} -DKDU_NO_THREADS"
	else
		LIBS="-lpthread"
	fi

	flags="${flags} ${CFLAGS}"

	if use mmx && use sse && use sse2; then
		flags="${flags} -mmmx -msse -msse2 -DKDU_X86_INTRINSICS"
	fi
	if use sse3; then
		flags="${flags} -msse3"
	else
		flags="${flags} -DKDU_NO_SSSE3"
	fi

	emake \
		CC=$(tc-getCXX) 				\
		CFLAGS="\${INCLUDES} ${flags}" 	\
		LDFLAGS="${LDFLAGS}" \
		LIBS="${LIBS}" \
		-C coresys/make -f ${makefile} all \
			|| die "Failed to build library"

	use doc && target=all || target=all_but_hyperdoc

	if use tools; then
		emake \
			CC=$(tc-getCXX) 							 \
			CFLAGS="\${INCLUDES} ${flags} \${DEFINES}" 	 \
			LDFLAGS="${LDFLAGS} -Wl,-as-needed"          \
			LIBS="-lm ${LIBS}"                           \
			-C apps/make -f ${makefile} ${target}		 \
				|| die "Failed to build tools"
	fi
}

src_install() {
	rm -f bin/*/simple* || die "Failed to remove examples"

	dobin bin/*/*    || die "Failed to install binaries"

	for libname in libkdu libkdu_apps; do
		local SONAME=${libname}${KAKADU_SONAME_VERSION}
		local NAME=${libname}${KAKADU_NEW_SUFFIX}

		mv lib/$(get_kdu_arch)/${NAME} lib/${SONAME} \
			|| die "Failed to rename lib to SONAME"

		dosym ${SONAME} ${ROOT}/usr/$(get_libdir)/${libname}$(get_libname) \
			|| die "Failed to create symlink"
		dosym ${SONAME} ${ROOT}/usr/$(get_libdir)/${NAME} \
			|| die "Failed to create symlink"
	done

	dolib.so lib/libkdu* || die "Failed to install shared library"

	for i in $(find coresys apps -name \*\.h); do
		insinto "/usr/include/kakadu/$(dirname $i)"
		doins $i || die "Could not install header"
	done

	sed -i \
		-e 	's#Overview\.txt#../&#'			\
	    -e 	's#Usage_Examples\.txt#../&#'	\
		-e	's#kakadu.pdf#../&#'         	\
			  	documentation/nav.html

	dohtml -r documentation/*.html documentation/html_pages
	insinto /usr/share/doc/${PF}/
	doins documentation/*.txt documentation/kakadu.pdf
}
