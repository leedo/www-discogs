#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib';
use WWW::Discogs;

my $discogs = WWW::Discogs->new(apikey => '5b4bea98ec');
if (my $artist = $discogs->artist('Ween')) {
	for ($artist->releases) {
		my $release = $discogs->release($_->{id});
		if (my @images = $release->primary_images) {
			print $release->title . "\n". $images[0]{uri} . "\n\n";
		}
	}
}
