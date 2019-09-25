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

my @sources = `wget -O - https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/youtube-sources.txt`;

my ($cat,$ytref);
foreach (@sources) {
	if (/^([^\/]+)\/([\w\-]{11})$/) {
		($cat,$ytref) = ($1, $2);
		if ($mode eq 'init') {
			system("mkdir \"$dest/$cat\"") unless (-d "$dest/$cat");
			system("cd \"$dest/$cat\" && youtube-dl -x --audio-format vorbis https://www.youtube.com/watch?v=$ytref --verbose");
		} elsif ($mode eq 'update') {
		}
	}
}

