# Native Authenticator ref https://blog.jupyter.org/simpler-authentication-for-small-scale-jupyterhubs-with-nativeauthenticator-999534c77a09
# https://native-authenticator.readthedocs.io/en/latest/index.html
# https://github.com/jupyterhub/ldapauthenticator/issues/54
from jupyter_client.localinterfaces import public_ips
import os, sys, subprocess

c.JupyterHub.admin_access = True

# c.JupyterHub.base_rul = ''
c.JupyterHub.bind_url = 'https://:3801/'

c.PAMAuthenticator.admin_groups = {'sudo'}
c.Authenticator.admin_users = {'cameo','iek','cameo2','hanes','caro'}

c.LocalAuthenticator.create_system_users = True

c.JupyterHub.ssl_key = '/var/ssl/private.key'
c.JupyterHub.ssl_cert = '/var/ssl/certificate.crt'
c.JupyterHub.cookie_secret_file = '/srv/jupyterhub/jupyterhub_cookie_secret'
c.Spawner.default_url = '/lab'


