# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-vpn/appgate"

ACCT_USER_ID=333
ACCT_USER_GROUPS=( appgate )
ACCT_USER_HOME=/var/lib/appgate

acct-user_add_deps
