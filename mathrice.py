"""
Custom Authenticator to use Mathrice OAuth with JupyterHub

Most of the code c/o Kyle Kelley (@rgbkrk)
"""


import json
import os

from tornado.auth import OAuth2Mixin
from tornado import gen, web

from tornado.httputil import url_concat
from tornado.httpclient import HTTPRequest, AsyncHTTPClient

from jupyterhub.auth import LocalAuthenticator

from traitlets import Unicode

from oauthenticator.oauth2 import OAuthLoginHandler, OAuthenticator

class MathriceMixin(OAuth2Mixin):
    # Taken from https://plm.wiki.math.cnrs.fr/servicesnumeriques/identites/oauth2
    _OAUTH_AUTHORIZE_URL = "https://plm.math.cnrs.fr/sp/oauth/authorize"
    _OAUTH_ACCESS_TOKEN_URL = "https://plm.math.cnrs.fr/sp/oauth/token"


class MathriceLoginHandler(OAuthLoginHandler, MathriceMixin):
    pass


class MathriceOAuthenticator(OAuthenticator):
    
    login_service = "Mathrice"
    login_handler = MathriceLoginHandler
    
    @gen.coroutine
    def authenticate(self, handler, data=None):
        code = handler.get_argument("code", False)
        if not code:
            raise web.HTTPError(400, "oauth callback made without a token")
        # TODO: Configure the curl_httpclient for tornado
        http_client = AsyncHTTPClient()
        
        # Exchange the OAuth code for a Mathrice Access Token
        #
        # See: https://developer.github.com/v3/oauth/
        
        # Mathrice specifies a POST request yet requires URL parameters
        params = dict(
            client_id=self.client_id,
            client_secret=self.client_secret,
            code=code
        )
        
        url = url_concat("https://plm.math.cnrs.fr/sp/oauth/token",
                         params)
        
        req = HTTPRequest(url,
                          method="POST",
                          headers={"Accept": "application/json"},
                          body='' # Body is required for a POST...
                          )
        
        resp = yield http_client.fetch(req)
        resp_json = json.loads(resp.body.decode('utf8', 'replace'))
        
        access_token = resp_json['access_token']
        
        # Determine who the logged in user is
        headers={"Accept": "application/json",
                 "User-Agent": "JupyterHub",
                 "Authorization": "token {}".format(access_token)
        }
        req = HTTPRequest("https://plm.math.cnrs.fr/sp/me",
                          method="GET",
                          headers=headers
                          )
        resp = yield http_client.fetch(req)
        resp_json = json.loads(resp.body.decode('utf8', 'replace'))

        print(resp_json)

        return resp_json["login"]


class LocalMathriceOAuthenticator(LocalAuthenticator, MathriceOAuthenticator):

    """A version that mixes in local system user creation"""
    pass

