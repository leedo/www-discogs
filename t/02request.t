use strict;
use warnings;

use Test::More tests => 6;

BEGIN { use_ok 'WWW::Discogs' }

my $apikey = '5b4bea98ec';

my $discogs = WWW::Discogs->new(apikey => $apikey);
is(ref $discogs, 'WWW::Discogs', "client");

my $res = $discogs->_request('search',{q => 'Ween', type => 'all'});
is($res->code, 200, "search");

$res = $discogs->_request('release/1');
is($res->code, 200, "release");

$res = $discogs->_request('artist/Ween');
is($res->code, 200, "artist");

$res = $discogs->_request('label/Svek');
is($res->code, 200, "label");
