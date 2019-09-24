# "Radio Londres 2.0" Installation
Nous avons documenté le déploiement en environnement Ubuntu 16.04 LTS (support jusqu'en avril 2023).

## Ubuntu 16.04 LTS - Déploiement des composants applicatifs

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

> # sudo tail -f /var/log/mpd.log
> # sudo tail -f /var/log/syslog |grep mpd

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

> # sudo tail -f /var/log/icecast2/access.log
> # sudo tail -f /var/log/icecast2/error.log

## Initialisation de la playlist
