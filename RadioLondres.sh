#!/bin/bash
#
# Script :	RadioLondres.sh
# Object :	Used to manage "Radio Londres 2.0" playlist
# Author :	Freddy Frouin <freddy@linuxtribe.fr>
#
# Date	 :	Mon Oct 14 14:22:33 CEST 2019
# Release:	0.1
#
# ChangeLog:	0.1 init
#
################################################################################

export ICECAST_PWD=YOUR_PASSWORD

export MPD=/usr/local/bin/mpd
export MPC=/usr/local/bin/mpc
export CURRENT=/var/lib/mpd/RadioLondres/RadioLondres.current
export CLIENTS=/var/lib/mpd/RadioLondres/RadioLondres.users
export LAST=/var/lib/mpd/RadioLondres/RadioLondres.last
export TMP=/var/lib/mpd/RadioLondres/tmp
export LOG=/var/lib/mpd/RadioLondres/log

function usage {
	echo "Usage:	$0 {bigben|radioLondres|gj|vp|media|politique|humour} {add|del}" 
	echo "	$0 program {RadioLondres|mdf}"
	echo "	$0 {health|publish-current|log}"
	echo
	echo "	$0 tools del <song_name>"
	echo "	$0 tools length {bigben|radioLondres|gj|vp|media|politique|humour}"
	echo "	$0 tools {check-playlist|reload|init}"
	echo "	$0 tools {yt-sources|tt-sources}"
	exit 1;
}

function geoip_log {
	cat $CLIENTS | while read line; do echo "[$(date)] $line" >>$LOG/$(date +%Y%m%d)_geoip_radioLondres.log; done
}

function log {
	echo "[$(date)]	$1 $2" >>$LOG/$(date +%Y%m%d)_radioLondres.log
}

function log_cron {
	echo "[$(date)]	$1 $2" >>$LOG/$(date +%Y%m%d)_cron_radioLondres.log
}

function insert {
	log_cron insert "$1"
	$MPC insert "$1"
}

function insert_rand {
	log_cron insert_rand "$1"
	if [ -z "$2" ]; then
		$MPC ls $1 |grep -vf $TMP/last.$1| shuf -n 1 > $TMP/last.$1
	else
		$MPC ls $1 |grep -vf $TMP/last.$1| shuf -n $2 > $TMP/last.$1
	fi
	cat $TMP/last.$1 |$MPC insert
	while read s; do
		log_cron insert_rand "$s"
	done <$TMP/last.$1
}

function delete {
	log_cron delete "$1"
	$MPC playlist > $TMP/RadioLondres.delete.playlist
	grep "$1" -nr $TMP/RadioLondres.delete.playlist |awk -F: '{print $1}' |$MPC del
}

function delete_rand {
	log_cron delete_rand "$1"
	while read s; do
		$MPC playlist > $TMP/RadioLondres.delete_rand.playlist
		grep "$s" -nr $TMP/RadioLondres.delete_rand.playlist |awk -F: '{print $1}' |$MPC del
		log_cron delete_rand "$s"
	done <$TMP/last.$1
}

case "$1" in
publish-current)
	$MPC current > $CURRENT
	scp $CURRENT YOUR_HOST:/tmp/ 
	scp $LOG/$(date +%Y%m%d)_radioLondres.log YOUR_HOST:/tmp/RadioLondres.today
	scp $CLIENTS YOUR_HOST:/tmp/RadioLondres.users
	scp $LOG/$(date +%Y%m%d -d "yesterday")_radioLondres.log YOUR_HOST:/tmp/RadioLondres.yesterday
	;;
health)
	p=$(ps -edf | grep -v grep |grep -c mpd.conf)
	case "$p" in
	0)
		echo "down - restarting"
		$MPD /etc/mpd.conf
		sleep 3
		$MPC play
		;;
	*)
		;;
	esac
	;;
log)
	geoip_log
	for i in `seq 1 58`;
	do
		sleep 1
		if ! [ "$($MPC current)" = "$(cat $LAST)" ]; then
			$MPC current >$LAST
			export CLIENTS=$(wget --user=admin --password=$ICECAST_PWD http://localhost:8000/admin/listmounts.xsl --quiet -O - |grep "Listener(s)" | head -1 | perl -pe 's/^.*(\d+).*$/$1/')
			export CLIENTS_LOW=$(wget --user=admin --password=$ICECAST_PWD http://localhost:8000/admin/listmounts.xsl --quiet -O - |grep "Listener(s)" | tail -1 | perl -pe 's/^.*(\d+).*$/$1/')

			echo "[$(date)]	[HQ:$CLIENTS LOW:$CLIENTS_LOW] $($MPC status | head -1)" >>$LOG/$(date +%Y%m%d)_radioLondres.log
		fi
	done
	;;
program)
	case "$2" in
	mdf)
		$MPC rm RadioLondres
		$MPC save RadioLondres
		$MPC current > $TMP/RadioLondres_program_$2.last
		$MPC crop
		$MPC ls mdf |$MPC add
                for i in `seq 1 100`; do
                        $MPC shuffle
                done
		$MPC next
		delete "$(cat $TMP/RadioLondres_program_$2.last)"
		;;
	RadioLondres)
		$MPC current > $TMP/RadioLondres_program_$2.last
		$MPC crop
		$MPC load RadioLondres
		$MPC next
		delete "$(cat $TMP/RadioLondres_program_$2.last)"
		;;
	*)
		usage;
		;;
	esac
	;;
bigben)
	case "$2" in
	add)
		$MPC shuffle
		insert clock/11h.ogg
		$MPC next
		;;
	del)
		delete clock/11h.ogg
		;;
	*)
		usage;
	esac
	;;
radioLondres)
	case "$2" in
	add)
		insert jingle/lfpaf_footer.ogg
		insert_rand radioLondres 3
		insert jingle/lfpaf_header2.ogg
		insert_rand cnr
		insert jingle/lfpaf_header.ogg
		;;
	del)
		delete jingle/lfpaf_header.ogg
		delete_rand radioLondres
		delete jingle/lfpaf_header2.ogg
		delete_rand cnr
		delete jingle/lfpaf_footer.ogg
		;;
	*)
		usage
		;;
	esac
	;;
vp)
	case "$2" in
        add)
		insert jingle/$1_footer.ogg
		insert_rand $1
		insert jingle/Notre_President_sur_les_violences_policieres_-_L_etat_de_droit-fcWZSfG0aCs.ogg
		insert jingle/$1_header1.ogg
		insert jingle/$1_header.ogg
                ;;
        del)
		delete jingle/$1_header.ogg
		delete jingle/$1_header1.ogg
		delete jingle/Notre_President_sur_les_violences_policieres_-_L_etat_de_droit-fcWZSfG0aCs.ogg
		delete_rand $1
		delete jingle/$1_footer.ogg
                ;;
	esac
	;;
gj)
	case "$2" in
	add)
		insert jingle/$1_footer.ogg
		insert_rand $1
		insert jingle/$1_header.ogg
		;;
	del)
		delete jingle/$1_header.ogg
		delete_rand $1
		delete jingle/$1_footer.ogg
		;;
	*)
		usage
		;;
	esac
	;;
politique)
	case "$2" in
	add)
		insert jingle/$1_footer.ogg
		insert_rand $1 3
		insert jingle/$1_header.ogg
		;;
	del)
		delete jingle/$1_header.ogg
		delete_rand $1
		delete jingle/$1_footer.ogg
		;;
	*)
		usage
		;;
	esac
	;;
media|humour)
	case "$2" in
	add)
		insert_rand $1
		;;
	del)
		delete_rand $1
		;;
	*)
		usage
		;;
	esac
	;;
tools)
	case "$2" in
	del)
		delete "$3"
		;;
	length)
		echo -n "$3 : " && cd "/var/lib/mpd/music/$3" && ogginfo *.ogg |grep Playback | awk '{print $3}' | awk -F: '{print $1 " " $2}' | perl -pe 's/(\d+)m\s([\d\.]+)s/$1 $2/' | awk '{ sum += (($1*60)+$2) } END { print sum/3600 }' | awk -F. '{print $1 "h" ($2*6)}' | perl -pe 's/^(\d+h\d{2})\d+$/$1/'
		;;
	check-playlist)
		$MPC playlist |grep -v chanson|grep -v accordeon|grep -v jazz
		;;
	reload)
		$MPC update
		$MPC crop
		$MPC ls chanson| $MPC add
                $MPC ls jazz | $MPC add
                $MPC ls accordeon | $MPC add
                for i in `seq 1 100`; do
                        $MPC shuffle
                done
		;;
	init)
		$MPC update
		$MPC clear
		$MPC ls chanson| $MPC add
		$MPC ls jazz | $MPC add
		$MPC ls accordeon | $MPC add
		for i in `seq 1 100`; do
			$MPC shuffle
		done
		$MPC play
		;;
	yt-sources)
		cd /var/lib/mpd/music && find . -type f |grep ogg$ | perl -pe 's/\.\/([^\/]+)\/.+\-([\w\d\_\-]{11})[\_\-]?\d?\d?\.ogg$/$1\/$2/' |grep -v ^\.\/ | uniq -u
		;;
	tt-sources)
		cd /var/lib/mpd/music && find . -type f |grep ogg$ | perl -pe 's/\.\/([^\/]+)\/.+\-(\d{19})[\_\-]?\d?\d?\.ogg$/$1\/$2/' |grep -v ^\.\/ | uniq -u
		;;
	*)
		usage
		;;
	esac
	;;
*)
	usage
	;;
esac

exit 0;
