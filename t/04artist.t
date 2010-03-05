use strict;
use warnings;

use Test::More tests => 7;

BEGIN { use_ok 'WWW::Discogs' }

my $apikey = '5b4bea98ec';

my $discogs = WWW::Discogs->new(apikey => $apikey);
is(ref $discogs, 'WWW::Discogs', "client");

my $artist = $discogs->artist("Bill Callahan");
is(ref $artist, 'WWW::Discogs::Artist', 'artist');

is_deeply($artist->name, "Bill Callahan", 'name');
is_deeply(($artist->namevariations)[0], "B. Callahan", 'namevariations');
is_deeply(($artist->aliases)[0], 'Smog', 'aliases');

for ($artist->releases) {
	if ($_->{id} == 975091) {
		is_deeply($_,
			{
				format		=> 'CD, Album',
				status		=> 'Accepted',
				label		=> 'Drag City',
				title		=> 'Woke On A Whaleheart',
				type		=> 'Main',
				id			=> '975091',
				year		=> '2007'
			}, 'release');
    last;
	}
}


