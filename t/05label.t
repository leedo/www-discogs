use strict;
use warnings;

use Test::More tests => 6;

BEGIN { use_ok 'WWW::Discogs' }

my $apikey = '5b4bea98ec';

my $discogs = WWW::Discogs->new(apikey => $apikey);
is(ref $discogs, 'WWW::Discogs', "client");

my $label = $discogs->label("Svek");
is(ref $label, 'WWW::Discogs::Label', 'label');

is($label->name, "Svek", "name");
is_deeply($label->sublabels, "Birdy",'sublabels');

for ($label->releases) {
	if ($_->{id} == 116265) {
		is_deeply($_, {
			'artist'	=> 'Calico',
			'format'	=> '12"',
			'status'	=> 'Accepted',
			'title'		=> 'Unfinished Diary Chapter One',
			'catno'		=> 'SK 001',
			'id'		=> '116265'}, 'release');
	}
}
