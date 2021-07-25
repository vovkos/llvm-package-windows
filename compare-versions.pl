use strict;

my ($version1, $version2) = ($ARGV[0], $ARGV[1]);
$version1 && $version2 || die("Usage: compare-versions.pl <version1> <version2>\nReturns -1, 0, or 1\n");

my @splitVersion1 = splitVersion($version1);
my @splitVersion2 = splitVersion($version2);

for (my $i = 0; $i < 3; $i++) {
	if ($splitVersion1[$i] < $splitVersion2[$i]) {
		exit(-1);
	}
	elsif ($splitVersion1[$i] > $splitVersion2[$i]) {
		exit(1);
	}
}

exit(0);

sub splitVersion {
	my ($version) = @_;

	$version =~ /([0-9]+)([.,\-]([0-9]+))?([.,\-]([0-9]+))?/;
	my $major = $1 || 0;
	my $minor = $3 || 0;
	my $patch = $5 || 0;

	return ($major, $minor, $patch);
}
