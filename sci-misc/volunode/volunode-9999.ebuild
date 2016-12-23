EAPI=6

inherit autotools eutils systemd user versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="Unix client for Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="https://github.com/boinc-next/volunode/"
RESTRICT="mirror"

# Configuration variables
RELEASE_VER=""
case ${PV} in
9999*)
	EGIT_REPO_URI="git://github.com/boinc-next/volunode.git"
	inherit git-r3
	;;
*)
	RELEASE_VER=${PV}
	;;
esac

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="curl_ssl_libressl +curl_ssl_openssl debug static-libs"

REQUIRED_USE="^^ ( curl_ssl_libressl curl_ssl_openssl ) "

# libcurl must not be using an ssl backend boinc does not support.
# If the libcurl ssl backend changes, boinc should be recompiled.
RDEPEND="
	>=app-misc/ca-certificates-20080809
        sci-misc/boinc-app-api
	net-misc/curl[-curl_ssl_gnutls(-),curl_ssl_libressl(-)=,-curl_ssl_nss(-),curl_ssl_openssl(-)=,-curl_ssl_axtls(-),-curl_ssl_cyassl(-),-curl_ssl_polarssl(-)]
	sys-apps/util-linux
	sys-libs/zlib
	dev-cpp/glibmm
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local NULL
	econf \
	    $(use_enable debug logtrace) \
	    ${NULL}
}

src_install() {
	default

	keepdir /var/lib/${PN}

	# cleanup cruft
	rm -rf "${ED%/}"/etc || die "rm failed"
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_preinst() {
	enewgroup ${PN}
	# note this works only for first install so we have to
	# elog user about the need of being in video group
	local groups="${PN}"
	groups+=",video"
	enewuser ${PN} -1 -1 /var/lib/${PN} "${groups}"
}

pkg_postinst() {
	elog
	elog "To be able to use GPGPU you should add volunode user to video group."
	elog "Run as root:"
	elog "gpasswd -a volunode video"
}
