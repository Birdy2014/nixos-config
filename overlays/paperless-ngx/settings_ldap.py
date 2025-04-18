import logging
import os
import ldap
from django_auth_ldap.config import LDAPSearch, GroupOfUniqueNamesType


# Reduce the ldap timeout so it doesn't hang forever if the connection
# to the ldap server fails.
ldap.set_option(ldap.OPT_NETWORK_TIMEOUT, 5)
ldap.set_option(ldap.OPT_TIMEOUT, 5)


logger = logging.getLogger(__name__)


def getenv_required(name: str) -> str:
    env = os.getenv(name)
    if env is None:
        logger.critical(f"Missing required settings {name}")
        exit(1)
    return env


AUTH_LDAP_SERVER_URI = getenv_required("AUTH_LDAP_SERVER_URI")
AUTH_LDAP_BIND_DN = getenv_required("AUTH_LDAP_BIND_DN")
password_file = getenv_required("AUTH_LDAP_BIND_PASSWORD_FILE")
with open(password_file, "r") as file:
    lines = file.read().splitlines()
    if len(lines) > 0:
        AUTH_LDAP_BIND_PASSWORD = lines[0]


ldap_user_base_dn = getenv_required("AUTH_LDAP_USER_BASE_DN")
ldap_user_filter = getenv_required("AUTH_LDAP_USER_FILTER")
AUTH_LDAP_USER_SEARCH = LDAPSearch(ldap_user_base_dn, ldap.SCOPE_SUBTREE, ldap_user_filter)


ldap_group_base_dn = getenv_required("AUTH_LDAP_GROUP_BASE_DN")
ldap_group_filter = "(objectClass=groupOfUniqueNames)"
AUTH_LDAP_GROUP_SEARCH = LDAPSearch(ldap_group_base_dn, ldap.SCOPE_SUBTREE, ldap_group_filter)
AUTH_LDAP_GROUP_TYPE = GroupOfUniqueNamesType()
AUTH_LDAP_MIRROR_GROUPS = True


AUTH_LDAP_REQUIRE_GROUP = getenv_required("AUTH_LDAP_REQUIRE_GROUP")


#
# Load the default Paperless settings
#

from .settings import *


# The Paperless mobile app fails if only the LDAPBackend is available
AUTHENTICATION_BACKENDS.insert(2, "django_auth_ldap.backend.LDAPBackend")


# Fixes Error 500 on /api/status/
# https://github.com/paperless-ngx/paperless-ngx/discussions/7211
_CHANNELS_REDIS_URL = os.getenv("PAPERLESS_REDIS", None)
