FROM lojzik/letsencrypt

# Expose SSL port
EXPOSE 443

# Declare volumes used by letsencrypt
VOLUME /etc/letsencrypt /var/lib/letsencrypt
