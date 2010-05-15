# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gdal/gdal-1.7.1-r1.ebuild,v 1.3 2010/04/30 08:18:41 scarabeus Exp $

EAPI="3"

WANT_AUTOCONF="2.5"
RUBY_OPTIONAL="yes"
USE_RUBY="ruby18"

inherit autotools eutils perl-module ruby toolchain-funcs

DESCRIPTION="GDAL is a translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="http://www.gdal.org/"
SRC_URI="http://download.osgeo.org/gdal/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x86-linux ~x86-macos"
# need to get these arches updated on several libs first
#KEYWORDS="~alpha ~hppa"

IUSE="curl debug doc ecwj2k fits geos gif gml hdf hdf5 jpeg jpeg2k mysql \
netcdf odbc png ogdi perl postgres python ruby sqlite threads bigtiff kakadu"

RDEPEND=">=sys-libs/zlib-1.1.4
	bigtiff?  ( =media-libs/tiff-4* )
	!bigtiff? ( >=media-libs/tiff-3.9.1 )
	sci-libs/libgeotiff
	dev-libs/expat
	curl? ( net-misc/curl )
	jpeg? ( media-libs/jpeg )
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	perl? ( dev-lang/perl )
	python? ( virtual/python
		dev-python/numpy )
	ruby? ( >=dev-lang/ruby-1.8.4.20060226 )
	fits? ( sci-libs/cfitsio )
	ogdi? ( sci-libs/ogdi )
	gml? ( >=dev-libs/xerces-c-3 )
	hdf5? ( >=sci-libs/hdf5-1.6.4 )
	postgres? ( virtual/postgresql-base )
	|| (
	    netcdf? ( sci-libs/netcdf )
	    hdf? ( sci-libs/hdf )
	)
	|| (
	    jpeg2k? ( media-libs/jasper )
	    ecwj2k? ( sci-libs/libecwj2 )
	)
	mysql? ( virtual/mysql )
	odbc?   ( dev-db/unixODBC )
	geos?   ( >=sci-libs/geos-2.2.1 )
	sqlite? ( >=dev-db/sqlite-3 )
	kakadu? ( media-libs/kakadu )"

DEPEND="${RDEPEND}
	perl? ( >=dev-lang/swig-1.3.32 )
	python? ( >=dev-lang/swig-1.3.32 )
	ruby? ( >=dev-lang/swig-1.3.32 )
	doc? ( app-doc/doxygen )"

EPATCH_OPTS="-F3"
AT_M4DIR="${S}/m4"

pkg_setup() {
	if [ -n "${GDAL_CONFIGURE_OPTS}" ]; then
	    elog "User-specified configure options are ${GDAL_CONFIGURE_OPTS}."
	else
	    elog "User-specified configure options are not set."
	    elog "If needed, set GDAL_CONFIGURE_OPTS to enable grass support."
	fi
}

src_prepare() {
	eaclocal
	eautoconf

	# this just preps the source for the last patch below
	sed -i -e "s|-Xcompiler -shared|-shared|" \
		swig/ruby/RubyMakefile.mk || die "sed failed"

	epatch "${FILESDIR}"/${PN}-1.4.2-datadir.patch \
	    "${FILESDIR}"/${PN}-1.5.1-python-install.patch \
	    "${FILESDIR}"/${PN}-1.6.0-swig-fix.patch \
	    "${FILESDIR}"/${PN}-1.6.1-ruby-make.patch \
	    "${FILESDIR}"/${P}-warp_fix.patch

	[[ ${CHOST} == *-darwin* ]] \
		&& epatch "${FILESDIR}"/${PN}-1.5.0-install_name.patch \
		|| epatch "${FILESDIR}"/${PN}-1.5.0-soname.patch

	if useq hdf && useq netcdf; then
		ewarn "Netcdf and HDF4 are incompatible due to certain tools in"
		ewarn "common; HDF5 is now the preferred choice for HDF data."
		die "Please disable either the hdf or netcdf use flag."
	fi
}

src_configure() {
	local pkg_conf="${GDAL_CONFIGURE_OPTS}"
	local use_conf=""

	pkg_conf="${pkg_conf} --enable-shared=yes --with-pic \
		--with-libgrass=no --without-libtool --with-expat=${EPREFIX}/usr"

	use_conf="$(use_with jpeg) $(use_with jpeg pcidsk) $(use_with png) $(use_with mysql) \
	    $(use_with postgres pg) $(use_with python) $(use_with ruby) \
	    $(use_with threads) $(use_with fits cfitsio) $(use_with perl) \
	    $(use_with netcdf) $(use_with hdf hdf4) $(use_with geos) \
	    $(use_with sqlite sqlite3 "${EPREFIX}"/usr) $(use_with jpeg2k jasper) $(use_with odbc) \
	    $(use_with gml xerces) $(use_with hdf5) $(use_with curl) \
		$(use_with kakadu kakadu /usr/include/kakadu) $(use_enable debug)"

	# It can't find this
	if useq ogdi ; then
	    use_conf="--with-ogdi=${EPREFIX}/usr ${use_conf}"
	fi

	if useq mysql ; then
	    use_conf="--with-mysql=${EPREFIX}/usr/bin/mysql_config ${use_conf}"
	fi

	if useq gif ; then
	    use_conf="--with-gif=internal ${use_conf}"
	else
	    use_conf="--with-gif=no ${use_conf}"
	fi

	if useq python ; then
	    use_conf="--with-pymoddir=${EPREFIX}/$(python_get_sitedir) ${use_conf}"
	fi

	if useq ruby ; then
	    RUBY_MOD_DIR=$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitearchdir"]')
	fi

	# Fix doc path just in case
	sed -i -e "s:@exec_prefix@/doc:@exec_prefix@/share/doc/${PF}/html:g" \
	    GDALmake.opt.in || die "sed gdalmake.opt failed"

	econf ${pkg_conf} ${use_conf} || die "econf failed"

	# mysql-config puts this in (and boy is it a PITA to get it out)
	sed \
	    -i -e "s;-Wl,-O1;;" \
	    -i -e "s| -rdynamic | |" \
	    GDALmake.opt || die "sed LIBS failed"

	# updated for newer swig (must specify the path to input files)
	if useq python; then
	    sed -i -e "s| gdal_array.i| ../include/gdal_array.i|" \
	        -i -e "s:\$(DESTDIR)\$(prefix):\$(DESTDIR)\$(INST_PREFIX):g" \
	        swig/python/GNUmakefile || die "sed python makefile failed"
	    sed -i -e "s#library_dirs = #library_dirs = /usr/$(get_libdir):#g" \
	        swig/python/setup.cfg || die "sed python setup.cfg failed"
	fi
}

src_compile() {
	local i
	for i in perl ruby python; do
		if useq $i; then
			rm "${S}"/swig/$i/*_wrap.cpp
			emake -C "${S}"/swig/$i generate || \
				die "make generate failed for swig/$i"
		fi
	done

	# parallel makes fail on the ogr stuff (C++, what can I say?)
	# also failing with gcc4 in libcsf
	emake -j1 || die "emake failed"

	if useq perl ; then
	    cd "${S}"/swig/perl
	    perl-module_src_prep
	    perl-module_src_compile
	    cd "${S}"
	fi

	if useq doc ; then
	    make docs || die "make docs failed"
	fi
}

src_install() {
	if useq perl ; then
	    cd "${S}"/swig/perl
	    perl-module_src_install
	    sed -i -e "s:BINDINGS        =       python ruby perl:BINDINGS        =       python ruby:g" \
		GDALmake.opt
	    cd "${S}"
	fi

	# einstall causes sandbox violations on /usr/lib/libgdal.so
	emake DESTDIR="${D}" install \
	    || die "make install failed"

	if useq ruby ; then
	    # weird reinstall collision; needs manual intervention...
	    cd "${S}"/swig/ruby
	    rm -rf "${D}"${RUBY_MOD_DIR}/gdal
	    exeinto ${RUBY_MOD_DIR}/gdal
	    doexe *.so || die "doins ruby modules failed"
	    cd "${S}"
	fi

	use perl && fixlocalpod

	dodoc Doxyfile HOWTO-RELEASE NEWS

	if useq doc ; then
	    dohtml html/* || die "install html failed"
	    docinto ogr
	    dohtml ogr/html/* || die "install ogr html failed"
	fi

	if useq python; then
	    newdoc swig/python/README.txt README-python.txt
	    dodir /usr/share/${PN}/samples
	    insinto /usr/share/${PN}/samples
	    doins swig/python/samples/*
	fi
}

pkg_postinst() {
	elog
	elog "If you need libgrass support, then you must rebuild gdal, after"
	elog "installing the latest Grass, and set the following option:"
	elog
	elog "GDAL_CONFIGURE_OPTS=--with-grass=\$GRASS_HOME emerge gdal"
	elog
	elog "GDAL is most useful with full graphics support enabled via various"
	elog "USE flags: png, jpeg, gif, jpeg2k, etc. Also python, fits, ogdi,"
	elog "geos, and support for either netcdf or HDF4 is available, as well as"
	elog "grass, and mysql, sqlite, or postgres (grass support requires grass 6"
	elog "and rebuilding gdal).  HDF5 support is now included."
	elog
	elog "Note: tiff and geotiff are now hard depends, so no USE flags."
	elog "Also, this package will check for netcdf before hdf, so if you"
	elog "prefer hdf, please emerge hdf with USE=szip prior to emerging"
	elog "gdal.  Detailed API docs require doxygen (man pages are free)."
	elog
	elog "Check available image and data formats after building with"
	elog "gdalinfo and ogrinfo (using the --formats switch)."
	elog
}
