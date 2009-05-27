# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"


MY_PN="${PN/visionworkbench/VisionWorkbench}"
DOWNLOAD_PV="${PV/_/-}"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="The NASA Vision Workbench (VW) is a general purpose image processing and computer vision library."
HOMEPAGE="http://ti.arc.nasa.gov/project/nasa-vision-workbench/"
SRC_URI="http://ti.arc.nasa.gov/m/project/nasa-vision-workbench/${MY_PN}-${DOWNLOAD_PV}.tar.gz"
LICENSE="NOSA"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="python dev hdf qt4"

BASE_DEPEND="
	dev? ( dev-util/lcov )
	dev-libs/boost
	virtual/blas
	virtual/lapack
	media-libs/libpng
	media-libs/jpeg
	media-libs/ilmbase
	media-libs/openexr
	hdf? ( sci-libs/hdf )
	sci-libs/gdal
	sci-libs/proj
	qt4? (
		x11-libs/qt-core:4
		x11-libs/qt-gui:4
		x11-libs/qt-sql:4
		x11-libs/qt-opengl:4
	)
"

DEPEND="
	${BASE_DEPEND}
	python? (
		>=dev-lang/python-2.4.4:2.4
		dev-python/numpy
		>=dev-lang/swig-1.3.29
	)
"

RDEPEND="
	${BASE_DEPEND}
	python? (
		>=dev-lang/python-2.4.4:2.4
		dev-python/numpy
	)
"

_add_line() {
	local opt="$1"
	shift 1
	echo "$*" >> "$opt"
}

src_compile() {
	local opt="${S}"/config.options

	cat > $opt <<- __EOF__
		ENABLE_DEBUG=ignore
		ENABLE_OPTIMIZE=ignore
		ENABLE_PROPER_LIBS=yes
		ENABLE_PKG_PATHS_DEFAULT=no
		PKG_PATHS="/usr"

		HAVE_PKG_CLAPACK=no
		HAVE_PKG_GLEW=no
		HAVE_PKG_CG=no

		PKG_SLAPACK_CPPFLAGS="$(pkg-config --cflags lapack)"
		PKG_PNG_CPPFLAGS="$(pkg-config --cflags libpng)"
		PKG_OPENEXR_CPPFLAGS="$(pkg-config --cflags OpenEXR)"
		PKG_ILMBASE_CPPFLAGS="$(pkg-config --cflags IlmBase)"

		PKG_SLAPACK_LIBS="$(pkg-config --libs lapack)"
		PKG_PNG_LIBS="$(pkg-config --libs libpng)"
		PKG_OPENEXR_LIBS="$(pkg-config --libs OpenEXR)"
		PKG_ILMBASE_LIBS="$(pkg-config --libs IlmBase)"
__EOF__

	if use qt4; then
		_add_line $opt 'PKG_QT_OPENGL_CPPFLAGS="' $(pkg-config --cflags QtOpenGL) '"'
		_add_line $opt 'PKG_QT_GUI_CPPFLAGS="'    $(pkg-config --cflags QtGui)    '"'
		_add_line $opt 'PKG_QT_SQL_CPPFLAGS="'    $(pkg-config --cflags QtSql)    '"'
		_add_line $opt 'PKG_QT_LIBS_LIBS="'       $(pkg-config --libs QtOpenGL)   '"'
	else
		_add_line $opt 'HAVE_PKG_QT_OPENGL=no'
		_add_line $opt 'HAVE_PKG_QT_GUI=no'
		_add_line $opt 'HAVE_PKG_QT_SQL=no'
		_add_line $opt 'HAVE_PKG_QT_LIBS=no'
	fi

	econf $(use_enable dev test-coverage) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS NOTES README
}
