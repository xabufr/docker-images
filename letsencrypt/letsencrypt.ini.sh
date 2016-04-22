#!/bin/bash

DOMAINS_LINE=$(jq -n -c -M --arg s "$DOMAINS" '$s|split(" ") as $array | $array|map(.|split(":")[0]) | join(", ")' -r)
cat > /letsencrypt.ini << EOF
# This is an example of the kind of things you can do in a configuration file.
# All flags used by the client can be configured here. Run Certbot with
# "--help" to learn more about the available options.

# Use a 4096 bit RSA key instead of 2048
rsa-key-size = 4096

# Uncomment and update to register with the specified e-mail address
email = ${EMAIL}

# Uncomment and update to generate certificates for the specified
# domains.
domains = ${DOMAINS_LINE}

# Uncomment to use a text interface instead of ncurses
# text = True

# Uncomment to use the standalone authenticator on port 443
# authenticator = standalone
# standalone-supported-challenges = tls-sni-01

# Uncomment to use the webroot authenticator. Replace webroot-path with the
# path to the public_html / webroot folder being served by your web server.
authenticator = webroot
webroot-path = ${WEBROOT}
EOF