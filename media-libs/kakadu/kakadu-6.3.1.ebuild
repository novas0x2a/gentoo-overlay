# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs multilib eutils flag-o-matic

KAKADU_ZIP_NAME=kakadu-${PV}.zip
KAKADU_LIST_CKSUM=dc6314024b1c95611629240f14a10411d4830853

KAKADU_MAJOR_VERSION=${PV%%.*}
KAKADU_POINT_VERSION=${PV##*.}
KAKADU_MINOR_VERSION=${PV%.*}
KAKADU_MINOR_VERSION=${KAKADU_MINOR_VERSION#*.}

KAKADU_LIB_STEM=libkdu

KAKADU_OLD_LIB_NAME=${KAKADU_LIB_STEM}_v63R.so
KAKADU_NEW_LIB_NAME=${KAKADU_LIB_STEM}$(get_libname ${PV})

# using their libname (ie, v63R) as inspiration, derive SONAME
KAKADU_SONAME=${KAKADU_LIB_STEM}$(get_libname ${KAKADU_MAJOR_VERSION}.${KAKADU_MINOR_VERSION})


DESCRIPTION="A JPEG2000 encoder/decoder implementing much of the spec"
HOMEPAGE="http://www.kakadusoftware.com/"
LICENSE="kakadu-noncommercial"
SLOT="0"
SRC_URI=""
KEYWORDS="~x86 ~amd64"
IUSE="mmx sse sse2 sse3 +tools +threads debug"
RESTRICT="bindist"

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

src_unpack() {
	local zip_path="${PORTDIR}/distfiles/${KAKADU_ZIP_NAME}"
	if [[ ! -f "${zip_path}" ]]; then
		eerror "You need to go to http://www.kakadusoftware.com/ and get a license."
		eerror "After you download your zip, rename it to kakadu-${PV}.zip"
		eerror "and put it at ${zip_path}."
		die "Missing ${KAKADU_ZIP_NAME}"
	fi

	# This will only protect against partial files... it won't protect against
	# intentional maliciousness.
	local list_chksum="$(unzip -l ${zip_path} | cut -d / -f 2- | sha1sum | cut -d ' ' -f 1)"

	if [[ ${list_chksum} != ${KAKADU_LIST_CKSUM} ]]; then
		die "Checksum failure! Please rm ${zip_path} and try again!";
	fi

	unzip -qo "${zip_path}" \
		|| die "Could not unzip ${zip_path}"

	mv v* ${P} || die "Could not remove license id from kakadu directory name"
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

	append-ldflags -Wl,-no-undefined

	sed -i \
		-e "s/${KAKADU_OLD_LIB_NAME}/${KAKADU_NEW_LIB_NAME}/g" \
		-e 's/$(LIBS)/$(LDFLAGS) $(LIBS)/g' \
		-e 's/-shared/$(LDFLAGS) -shared $(LIBS)/g' \
		-e 's/ -lpthread//g' \
		coresys/make/${makefile} \
		apps/make/${makefile} \
			|| die "Failed to mangle makefiles"

	emake \
		CC=$(tc-getCXX) 				\
		CFLAGS="\${INCLUDES} ${flags}" 	\
		LDFLAGS="${LDFLAGS} -Wl,-soname,${KAKADU_SONAME}" \
		LIBS="${LIBS}" \
		-C coresys/make -f ${makefile} all \
			|| die "Failed to build library"

	if use tools; then
		emake \
			CC=$(tc-getCXX) 							 \
			CFLAGS="\${INCLUDES} ${flags} \${DEFINES}" 	 \
			LDFLAGS="${LDFLAGS} -Wl,-as-needed"          \
			LIBS="-lm ${LIBS}"                           \
			-C apps/make -f ${makefile} all_but_hyperdoc \
				|| die "Failed to build tools"
	fi
}

src_install() {
	rm bin/*/simple* || die "Failed to remove examples"

	dobin bin/*/*    || die "Failed to install binaries"

	mv lib/$(get_kdu_arch)/${KAKADU_NEW_LIB_NAME} lib/${KAKADU_SONAME} \
		|| die "Failed to rename lib to SONAME"

	dosym ${KAKADU_SONAME} ${ROOT}/usr/$(get_libdir)/${KAKADU_LIB_STEM}$(get_libname) \
		|| die "Failed to create symlink"
	dosym ${KAKADU_SONAME} ${ROOT}/usr/$(get_libdir)/${KAKADU_NEW_LIB_NAME} \
		|| die "Failed to create symlink"

	dolib.so lib/${KAKADU_LIB_STEM}* || die "Failed to install shared library"
}
