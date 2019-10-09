#!/usr/bin/perl

sub usage {
	print "Usage: $0 {init|update} <path>\n";
	exit 1;
}

usage unless (defined($ARGV[0]));
usage unless ($ARGV[0] =~ /^(init|update)$/);
usage unless (defined($ARGV[1]));
usage unless (-d "$ARGV[1]");

my $mode = $ARGV[0];
my $dest = $ARGV[1];

my @sources_yt = `wget -O - https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/youtube-sources.txt`;
my @sources_tt = `wget -O - https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/twitter-sources.txt`;

my ($cat,$ytref);

foreach (@sources_tt) {
	if (/^([^\/]+)\/([\w\-]{19})$/) {
		($cat,$ytref) = ($1, $2);
		if ($mode eq 'init') {
			system("mkdir \"$dest/$cat\"") unless (-d "$dest/$cat");
			system("cd \"$dest/$cat\" && youtube-dl --restrict-filenames -x --audio-format vorbis https://twitter.com/Reporterre/status/$ytref --verbose");
		} elsif ($mode eq 'update') {
		}
	}
}

foreach (@sources_yt) {
	if (/^([^\/]+)\/([\w\-]{11})$/) {
		($cat,$ytref) = ($1, $2);
		if ($mode eq 'init') {
			system("mkdir \"$dest/$cat\"") unless (-d "$dest/$cat");
			system("cd \"$dest/$cat\" && youtube-dl --restrict-filenames -x --audio-format vorbis https://www.youtube.com/watch?v=$ytref --verbose");
		} elsif ($mode eq 'update') {
		}
	}
}

