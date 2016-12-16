EAPI=6

inherit autotools eutils git-r3

REPO_USER="boinc-next"
REPO_NAME="boinc-app-api"

DESCRIPTION="API for communication with BOINC applications"
HOMEPAGE="https://boinc-next.github.io/"
EGIT_REPO_URI="https://github.com/${REPO_USER}/${REPO_NAME}.git"
EGIT_COMMIT="${PV}"
RESTRICT="mirror"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf
}

src_install() {
	default
}
