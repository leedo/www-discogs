package WWW::Discogs;

use strict;
use warnings;

use LWP::UserAgent;
use URI;
use URI::Escape;
use URI::QueryParam;
use Compress::Zlib;
use XML::Simple;
use Encode;

use WWW::Discogs::Release;
use WWW::Discogs::Artist;
use WWW::Discogs::Label;
use WWW::Discogs::Search;

use 5.008;
our $VERSION = '0.10';

=head1 NAME

WWW::Discogs - get music related information and images

=cut

=head1 DESCRIPTION

Interface with discogs.com api to get music related information and
images.

=cut

=head1 SYNOPSIS

	use WWW:Discogs;

	my $client = WWW::Discogs->new(apikey => 1234567);

	# Print all artist images from a search
	#
	my $search = $client->search("Ween");
	
	for my $result ($search->exactresults) {
		if ($result->{type} eq 'artist') {
			my $artist = $client->artist( $result->{title} );
			print $artist->name . "\n";
			if ($artist->images) {
				print join "\n", $artist->images;
			}
		}
	}

	# Print all the album covers for an artist
	#
	my $artist = $client->artist("Ween");
	for my ($artist->releases) {
		my $release = $client->release($_->{id});
		if ($release->images) {
			print $release->title . "\n";
			if ($release->primaryimages) {
				print join "\n", $release->primaryimages;
			}
		}
	}
=cut

=head1 METHODS

=cut

=head2 new( %params )

Create a new instance. Takes a hash which must contain an 'apikey' item. You may also
provide an 'apiurl' item to change the url that is queried (default is www.discogs.com).

=cut
sub new {
    my ($class, @args) = @_;
    my $self = {};
    bless $self, $class;
    $self->_init(@args);
    
    return $self;
}

sub _init {
    my ($self, %args) = @_;

    $self->{apiurl} = $args{apiurl} || 'http://api.discogs.com';
    $self->{ua} = LWP::UserAgent->new;
    $self->{ua}->default_header(
        'Accept-Encoding' => 'gzip, deflate',
        );

    return $self;
}

=head2 search( $searchstring )

Returns a L<WWW::Discogs::Search> object.

=cut

sub search {
	my ($self, $query, $type) = @_;
	my $res = $self->_request('search', {
		q		=> $query,
		type	=> $type || 'all',
	});
	
	if ($res->is_success) {
		my $xml = XMLin($res->content, ForceArray => ['result']);
		if ($xml->{stat} eq 'ok' && $xml->{searchresults}->{numResults} > 0) {
			return WWW::Discogs::Search->new(%$xml);
		}
	}

	return undef;
}

=head2 release( $release_id )

Returns a L<WWW::Discogs::Release> object. You can get a $release_id from a search,
artist, or label.

=cut

sub release {
	my ($self, $release) = @_;
	if ($release =~ /^\d+$/) {
		my $res = $self->_request("release/" . uri_escape($release));
		if ($res->is_success) {
			my $xml = XMLin($res->content, ForceArray => [ 
				'image',		'style',	'track',
				'format',		'note',		'description',
				'extraartist',	'genre',	'artist',
				'label',
			],KeyAttr => []);
			if ($xml->{stat} eq 'ok' and exists $xml->{release}) {
				return WWW::Discogs::Release->new(%{$xml->{release}});
			}
		}
	}
	
	return undef;
}

=head2 artist( $artist_name )

Returns a L<WWW::Discogs::Artist> object. You can get the exact name of an artist
from a search result's title.

=cut

sub artist {
	my ($self, $artist) = @_;
	my $res = $self->_request("artist/" . uri_escape($artist));
	if ($res->is_success) {
		my $xml = XMLin($res->content,
			ForceArray => ['image','name'], KeyAttr => ['name']);
		if ($xml->{stat} eq 'ok' and exists $xml->{artist}) {
			return WWW::Discogs::Artist->new(%{$xml->{artist}});
		}
	}

	return undef;
}

=head2 label( $label_name )

Returns a L<WWW::Discogs::Label> object. You can get the exact name of a label
from a search result's title.

=cut

sub label {
	my ($self, $label) = @_;
	my $res = $self->_request("label/" . uri_escape($label));
	if ($res->is_success) {
		my $xml = XMLin($res->content, ForceArray => [
			'release','image','sublabels'], KeyAttr => ['label']);
		if ($xml->{stat} eq 'ok' and exists $xml->{label}) {
			return WWW::Discogs::Label->new(%{$xml->{label}});
		}
	}
	
	return undef;
}

sub _request {
	my ($self, $path, $params) = @_;
	my $url = $self->_create_url($path,$params);
	my $res = $self->{ua}->get($url, 'Accept-Encoding' => 'gzip');
	if ($res->is_success) {
		if ($res->content_encoding and $res->content_encoding eq 'gzip') {
			$res->content(Compress::Zlib::memGunzip( $res->content ));
		}
	}
	return $res;
}

sub _create_url {
	my ($self, $path, $params) = @_;

	$params->{f} = 'xml';
	$params->{api_key} = $self->{apikey};

	my $uri = URI->new($self->{apiurl},"http");
	$uri->path($path);
	$uri->query_form_hash($params);

	return $uri->canonical->as_string;
}

=head1 AUTHOR

Lee Aylward <lee@laylward.com>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
