# "Radio Londres 2.0" - Installation -  Ubuntu 16.04 LTS
Nous avons documenté le déploiement en environnement Ubuntu 16.04 LTS (support jusqu'en avril 2023).

## Déploiement des composants applicatifs

### MPD

#### Installation

> # sudo apt install mpd mpc

#### Configuration

> # sudo vi /etc/mpd.conf

```
music_directory		"/var/lib/mpd/music"
playlist_directory		"/var/lib/mpd/playlists"
db_file			"/var/lib/mpd/tag_cache"
log_file			"/var/log/mpd/mpd.log"
pid_file			"/run/mpd/pid"
state_file			"/var/lib/mpd/state"
sticker_file                   "/var/lib/mpd/sticker.sql"
user				"mpd"
bind_to_address		"127.0.0.1"
log_level			"verbose"
auto_update    "yes"
input {
        plugin "curl"
}
audio_output {
        type "ao"
        driver "null"
        name "Dummy output"
}
audio_output {
	type		"shout"
	encoding	"ogg"			# optional
	name		"Radio Londres"
	host		"localhost"
	port		"8000"
	mount		"/radioLondres.ogg"
	password	"VOTRE_MOT_DE_PASSE_SOURCE"
	bitrate		"128"
	format		"44100:16:1"
	protocol	"icecast2"		# optional
	user		"source"		# optional
	genre		"mixed"		# optional
	public		"yes"			# optional
	mixer_type      "software"              # optional
}
volume_normalization		"yes"
filesystem_charset		"UTF-8"
id3v1_encoding			"UTF-8"
```
#### Démarrage

> # sudo systemctl enable mpd
> # sudo systemctl start mpd

#### Logs

> # sudo tail -f /var/log/syslog |grep mpd

### Icecast2

#### Installation

> # sudo apt install icecast2

#### Configuration

> # sudo vi /etc/icecast2/icecast.xml

```
<icecast>
      <location>VOTRE_LIEU</location>
      <admin>VOTRE_EMAIL</admin>

<authentication>
      <source-password>VOTRE_MOT_DE_PASSE_SOURCE</source-password>
      <relay-password>VOTRE_MOT_DE_PASSE_RELAIS</relay-password>
      <admin-password>VOTRE_MOT_DE_PASSE_ADMIN</admin-password>
</authentication>
```

#### Démarrage

> # sudo systemctl enable icecast2
> # sudo systemctl start icecast2

#### Logs

> # sudo tail -f /var/log/icecast2/error.log

### Nginx

#### Installation

> # sudo apt-get install nginx

#### Configuration

> # sudo vi /etc/nginx/sites-enabled/default

```
server {
	listen 51.15.178.55:8080;
	server_name VOTRE_NOM_D_HOTE;

	root /var/www/VOTRE_NOM_D_HOTE/htdocs;

	ssl on;
	ssl_certificate /etc/letsencrypt/live/VOTRE_NOM_D_HOTE/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/VOTRE_NOM_D_HOTE/privkey.pem;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
	ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
	ssl_session_cache shared:SSL:10m;
	ssl_session_tickets off; # Requires nginx >= 1.5.9
	ssl_stapling on; # Requires nginx >= 1.3.7
	ssl_stapling_verify on; # Requires nginx => 1.3.7
	resolver_timeout 5s;
	add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
	add_header X-Frame-Options DENY;
	add_header X-Content-Type-Options nosniff;

	proxy_set_header Host $host;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_set_header X-Forwarded-Host $host;
	proxy_set_header X-Forwarded-Server $host;
	proxy_set_header X-Real-IP $remote_addr;
	location / {
		proxy_pass http://127.0.0.1:8000/radioLondres.ogg;
		allow VOTRE_IP_CLIENT;
		deny all;
	}
	location /radioLondres.ogg {
		proxy_pass http://127.0.0.1:8000/radioLondres.ogg;
		allow all;
	}

	location /admin/ {
		proxy_pass http://127.0.0.1:8000/;
		allow VOTRE_IP_CLIENT;
		deny all;
	}

	location /server_version.xsl {
		proxy_pass http://127.0.0.1:8000/;
		allow VOTRE_IP_CLIENT;
		deny all;
	}
}

```

#### Démarrage

> # sudo systemctl enable nginx
> # sudo systemctl start nginx

#### Logs

> # sudo tail -f /var/log/nginx/error.log

## Initialisation de la playlist
