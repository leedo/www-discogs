use strict;
use warnings;

use Test::More tests => 10;

BEGIN { use_ok 'WWW::Discogs', 'WWW::Discogs::Search' }

my $discogs = WWW::Discogs->new;
is(ref $discogs, 'WWW::Discogs', 'client');

my $search = $discogs->search(q => 'Ween');
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

like($search->numresults, qr/^\d+$/, 'numresults');
like($search->pages, qr/^\d+$/, 'pages');
is($search->page, 1, 'page');
