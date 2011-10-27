use strict;
use warnings;

use Test::Mock::LWP::Dispatch;
use HTTP::Response;
use FindBin qw( $Bin );
use File::Slurp qw( read_file );

use Test::More tests => 9;
use Test::Deep;

BEGIN { use_ok 'WWW::Discogs' }

my $rt = read_file("$Bin/../requests/label.res");
my $response = HTTP::Response->parse($rt);
$mock_ua->map('http://api.discogs.com/label/Svek?releases=1', $response);

my $discogs = WWW::Discogs->new;
is(ref $discogs, 'WWW::Discogs', 'client');

my $label = $discogs->label(name => 'Svek', releases => 1);
is(ref $label, 'WWW::Discogs::Label', 'label');

like($label->contactinfo, qr/^Svek office/, 'contactinfo');
is($label->parentlabel, 'Goldhead Music', 'parentlabel');

is($label->name, 'Svek', 'name');
my @sublabels = $label->sublabels;
cmp_deeply(\@sublabels, bag( 'Birdy' ),'sublabels');

for ($label->releases) {
    if ($_->{id} == 116265) {
        is_deeply($_, {
            artist => 'Calico',
            format => '12"',
            status => 'Accepted',
            title  => 'Unfinished Diary Chapter One',
            catno  => 'SK 001',
            id     => '116265',
            thumb  => 'http://api.discogs.com/image/R-150-116265-1259504923.jpeg'
            }, 'releases');
    }
}

my @images = $label->images(type => 'primary');
cmp_deeply(\@images, bag({
            uri150 => 'http://api.discogs.com/image/L-150-5-1136662517.jpeg',
            width  => 600,
            type   => 'primary',
            height => 337,
            uri    => 'http://api.discogs.com/image/L-5-1136662517.jpeg'
        }), 'images');
