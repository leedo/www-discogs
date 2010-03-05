use strict;
use warnings;

use Test::More tests => 7;

BEGIN { use_ok 'WWW::Discogs' }

my $apikey = '5b4bea98ec';

my $discogs = WWW::Discogs->new(apikey => $apikey);
is(ref $discogs, 'WWW::Discogs', "client");

my $search = $discogs->search("Ween");
is(ref $search, 'WWW::Discogs::Search', 'search');

for ($search->exactresults) {
	if ($_->{title} eq 'Ween') {
		is($_->{type}, 'artist', 'exact type');
		is($_->{title}, 'Ween', 'exact artist');
	}
}

for ($search->searchresults) {
	if ($_->{title} eq 'Ween') {
		is($_->{type}, 'artist', 'search type');
		is($_->{title}, 'Ween', 'search artist');
	}
}
