#!/bin/sh

cat << EOS > Oak/Config/client_secret_generated.json
{
  "installed": {
    "auth_uri":"https://accounts.google.com/o/oauth2/auth",
    "client_secret":"${GOOGLE_API_CLIENT_SECRET}",
    "token_uri":"https://accounts.google.com/o/oauth2/token",
    "client_email":"",
    "redirect_uris":["urn:ietf:wg:oauth:2.0:oob","oob"],
    "client_x509_cert_url":"",
    "client_id":"${GOOGLE_API_CLIENT_ID}",
    "auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs"
  }
}
EOS