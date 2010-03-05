use strict;
use warnings;

use Test::More tests => 6;

BEGIN { use_ok 'WWW::Discogs' }

my $apikey = '5b4bea98ec';

my $discogs = WWW::Discogs->new(apikey => $apikey);
is(ref $discogs, 'WWW::Discogs', "client");

my $url = $discogs->_create_url('search', {q => 'query param', type => 'all'});
is($url, "http://www.discogs.com/search?q=query+param&type=all&api_key=$apikey&f=xml", "search");

$url = $discogs->_create_url('release/1');
is($url, "http://www.discogs.com/release/1?api_key=$apikey&f=xml", "release");

$url = $discogs->_create_url('artist/Ween');
is($url, "http://www.discogs.com/artist/Ween?api_key=$apikey&f=xml", "artist");

$url = $discogs->_create_url('label/Svek');
is($url, "http://www.discogs.com/label/Svek?api_key=$apikey&f=xml", "artist");
