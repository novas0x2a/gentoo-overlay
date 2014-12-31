EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit python distutils vcs-snapshot

DESCRIPTION="Python Module"
HOMEPAGE=""
SRC_URI="${PN}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE=""
KEYWORDS="amd64"
SLOT="0"
IUSE=""

CDEPEND="dev-python/setuptools
dev-python/django-compressor
dev-python/python-cinderclient
dev-python/python-glanceclient
dev-python/python-novaclient
dev-python/python-quantumclient
"

DEPEND="net-libs/nodejs ${CDEPEND}"
RDEPEND="${CDEPEND}"

src_prepare() {
	cp manage.py openstack-dashboard-admin.py
	sed -i -e 's/setup(.*/&\n      scripts=["openstack-dashboard-admin.py"],/' setup.py
}

distutils_src_install_pre_hook() {
	# Make nodejs stuff static.
	echo "COMPRESS_OFFLINE = True
COMPRESS_ENABLED = True
STATIC_ROOT='openstack_dashboard/static/'" > ${S}/openstack_dashboard/local/local_settings.py || die

	PYTHONPATH="${S}/openstack_dashboard" "$(PYTHON)" -B ./manage.py compress || die
	rm ./openstack_dashboard/local/local_settings.py || die
	find openstack_dashboard/static/dashboard -type f -exec chmod 644 {} ';' || die
}
