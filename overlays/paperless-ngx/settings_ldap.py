import logging
import os
import ldap
from django_auth_ldap.config import LDAPSearch


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


ldap_base_dn = getenv_required("AUTH_LDAP_BASE_DN")
ldap_user_filter = getenv_required("AUTH_LDAP_USER_FILTER")
AUTH_LDAP_USER_SEARCH = LDAPSearch(ldap_base_dn, ldap.SCOPE_SUBTREE, ldap_user_filter)


#
# Load the default Paperless settings
#

from .settings import *


# The Paperless mobile app fails when the AUTHENTICATION_BACKENDS when only the LDAPBackend is active
AUTHENTICATION_BACKENDS.insert(2, "django_auth_ldap.backend.LDAPBackend")
