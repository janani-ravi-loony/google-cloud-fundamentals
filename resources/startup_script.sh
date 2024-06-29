apt-get update
apt-get install nginx -y
cat <<EOF >/var/www/html/index.nginx-debian.html
<html><body><h1>WELCOME</h1>
<p>And this is how you use startup scripts on the GCP!</p>
</body></html>
EOF
