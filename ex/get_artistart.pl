#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib';
use WWW::Discogs;

my $discogs = WWW::Discogs->new(apikey => '5b4bea98ec');
if (my $artist = $discogs->artist('Ween')) {
	for ($artist->images) {
		print "$_->{uri}\n";
	}
}
