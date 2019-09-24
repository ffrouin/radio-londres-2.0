#!/bin/bash

function usage {
	echo "Usage:	$0 <bigben|radioLondres|gj|media|politique|humour> <add|del>" 
	echo "	$0 <health|publish-current>"
	exit 1;
}

case "$1" in
publish-current)
	mpc current > ~/RadioLondres.current
	scp RadioLondres.current VOTRE_HOTE_WEB:/tmp/ 
	;;
health)
	p=$(ps -edf | grep -v grep |grep -c mpd.conf)
	case "$p" in
	0)
		echo "down - restarting"
		/usr/local/bin/mpd /etc/mpd.conf
		sleep 3
		mpc play
		;;
	*)
		;;
	esac
	;;
bigben)
	case "$2" in
	add)
		mpc current > ~/RadioLondres.current
		mpc insert clock/11h.ogg
		mpc next
		mpc shuffle
		;;
	del)
		mpc playlist > RadioLondres.playlist
		grep 11h.ogg -nr ~/RadioLondres.playlist |awk -F: '{print $1}' |mpc del
		;;
	*)
		usage;
	esac
	;;
radioLondres)
	case "$2" in
	add)
		mpc insert jingle/lfpaf_footer.ogg
		mpc ls radioLondres |grep -vf ~/RadioLondres.lfpaf |shuf -n 1 > ~/RadioLondres.lfpaf
		cat ~/RadioLondres.lfpaf |mpc insert
		mpc insert jingle/lfpaf_header.ogg
		;;
	del)
		mpc playlist > RadioLondres.playlist
		grep -f ~/RadioLondres.lfpaf -nr ~/RadioLondres.playlist |awk -F: '{print $1}' |mpc del
		mpc playlist > RadioLondres.playlist
		grep lfpaf_header -nr ~/RadioLondres.playlist |awk -F: '{print $1}' |mpc del
		mpc playlist > RadioLondres.playlist
		grep lfpaf_footer -nr ~/RadioLondres.playlist |awk -F: '{print $1}' |mpc del
		;;
	*)
		usage
		;;
	esac
	;;
gj|politique)
	case "$2" in
	add)
		mpc insert jingle/$1_footer.ogg
		mpc ls $1 |grep -vf ~/RadioLondres.$1 |shuf -n 1 > ~/RadioLondres.$1
		cat ~/RadioLondres.$1 |mpc insert
		mpc insert jingle/$1_header.ogg
		;;
	del)
		mpc playlist > RadioLondres.playlist
		grep -f ~/RadioLondres.$1 -nr ~/RadioLondres.playlist |awk -F: '{print $1}' |mpc del
		mpc playlist > RadioLondres.playlist
		grep $1_header -nr ~/RadioLondres.playlist |awk -F: '{print $1}' |mpc del
		mpc playlist > RadioLondres.playlist
		grep $1_footer -nr ~/RadioLondres.playlist |awk -F: '{print $1}' |mpc del
		;;
	*)
		usage
		;;
	esac
	;;
media|humour)
	case "$2" in
	add)
		mpc ls $1 |grep -vf ~/RadioLondres.$1 |shuf -n 1 > ~/RadioLondres.$1
		cat ~/RadioLondres.$1 |mpc insert
		;;
	del)
		mpc playlist > RadioLondres.playlist
		grep -f ~/RadioLondres.$1 -nr ~/RadioLondres.playlist |awk -F: '{print $1}' |mpc del
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
