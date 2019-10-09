#!/bin/bash

export MPD=/usr/local/bin/mpd
export MPC=/usr/local/bin/mpc
export TMP=/var/lib/mpd/RadioLondres/tmp

function usage {
	echo "Usage:	$0 {bigben|radioLondres|gj|vp|media|politique|humour} {add|del}" 
	echo "	$0 {health|publish-current}"
	echo
	echo "	$0 tools del <song_name>"
	echo "	$0 tools {check-playlist|init}"
	exit 1;
}

function insert {
	$MPC insert $1
}

function insert_rand {
	
	if [ -z "$2" ]; then
		$MPC ls $1 |grep -vf $TMP/last.$1| shuf -n 1 > $TMP/last.$1
	else
		$MPC ls $1 |grep -vf $TMP/last.$1| shuf -n $2 > $TMP/last.$1
	fi
	cat $TMP/last.$1 |$MPC insert
}

function delete {
	$MPC playlist > $TMP/RadioLondres.delete.playlist
	grep $1 -nr $TMP/RadioLondres.delete.playlist |awk -F: '{print $1}' |$MPC del
}

function delete_rand {
	while read s; do
		$MPC playlist > $TMP/RadioLondres.delete_rand.playlist
		grep "$s" -nr $TMP/RadioLondres.delete_rand.playlist |awk -F: '{print $1}' |$MPC del
	done <$TMP/last.$1
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
		insert jingle/$1_header.ogg
                ;;
        del)
		delete jingle/$1_header.ogg
		delete_rand $1
		delete jingle/$1_footer.ogg
                ;;
	esac
	;;
gj|politique)
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
	init)
		$MPC stop
		$MPC clear
		$MPC ls chanson| $MPC add
		$MPC ls jazz | $MPC add
		$MPC ls accordeon | $MPC add
		for i in `seq 1 100`; do
			$MPC shuffle
		done
		$MPC play
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
