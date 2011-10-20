use strict;
use warnings;

use Test::More tests => 6;

BEGIN { use_ok 'WWW::Discogs' }

my $discogs = WWW::Discogs->new;
is(ref $discogs, 'WWW::Discogs', "client");

my $res = $discogs->_request(
    path => 'search',
    query => { q => 'adam beyer', type => 'artist' } 
);
is($res->code, 200, "search");

$res = $discogs->_request(path => 'release/1');
is($res->code, 200, "release");

$res = $discogs->_request(path => 'artist/Ween', query => { releases => 1} );
is($res->code, 200, "artist");

$res = $discogs->_request(path => 'label/Svek', query => { releases => 1} );
is($res->code, 200, "label");
