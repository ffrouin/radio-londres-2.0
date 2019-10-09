#!/bin/bash

export MPD=/usr/local/bin/mpd
export MPC=/usr/local/bin/mpc
export TMP=/var/lib/mpd/RadioLondres/tmp

function usage {
	echo "Usage:	$0 {bigben|radioLondres|gj|vp|media|politique|humour} {add|del}" 
	echo "	$0 {health|publish-current}"
	echo
	echo "	$0 tools del <song_name>"
	echo "	$0 tools check-playlist"
	exit 1;
}

function insert {
	$MPC insert $1
}

function insert_rand {
	$MPC ls $1 |grep -vf $TMP/last.$1| shuf -n 1 > $TMP/last.$1
	cat $TMP/last.$1 |$MPC insert
}

function delete {
	$MPC playlist > $TMP/RadioLondres.delete.playlist
	grep $1 -nr $TMP/RadioLondres.delete.playlist |awk -F: '{print $1}' |$MPC del
}

function delete_rand {
	$MPC playlist > $TMP/RadioLondres.delete_rand.playlist
	grep -f $TMP/last.$1 -nr $TMP/RadioLondres.delete_rand.playlist |awk -F: '{print $1}' |$MPC del
}

case "$1" in
publish-current)
	$MPC current > ~/RadioLondres/RadioLondres.current
	scp ~/RadioLondres/RadioLondres.current ns5.linuxtribe.fr:/tmp/ 
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
		insert_rand radioLondres
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
		insert jingle/$1_header.ogg
                ;;
        del)
		delete jingle/$1_header.ogg
		delete jingle/Notre_President_sur_les_violences_policieres_-_L_etat_de_droit-fcWZSfG0aCs.ogg
		delete_rand $1
		delete jingle/$1_footer.ogg
                ;;
	esac
	;;
gj|politique)
	case "$2" in
	add)
		insert jingle/$1_footer.ogg
		insert_rand gj
		insert jingle/$1_header.ogg
		;;
	del)
		delete jingle/$1_header.ogg
		delete_rand gj
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
		delete $3
		;;
	check-playlist)
		/usr/local/bin/mpc playlist |grep -v chanson|grep -v accordeon|grep -v jazz
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
