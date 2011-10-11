package WWW::Discogs;

use strict;
use warnings;

use LWP::UserAgent;
use URI;
use URI::Escape;
use Carp;
use JSON::XS;

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

	my $client = WWW::Discogs->new;

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

Create a new instance. You may also provide an 'apiurl' item to change the url that is queried (default is api.discogs.com).

=cut

our @namespaces = qw ( Artist Release Label Search Master );

my %query_params  = ( 
    artist  => { releases => 0, },
    release => { },
    label   => { releases => 0, },
    search  => { type => 'all', 'q' => '', page => '1', },
    master  => { },
    );

for (@namespaces) {
    my $pkg = __PACKAGE__."::$_";
    my $name = "\L$_";

    my $namespace = eval qq{
	use $pkg;

	sub $name {
	    my (\$self, \%args) = \@_;
	    
	    my \$id = \$args{id} || \$args{name} || '';

            my \$query_params = \$self->_get_query_params('$name', \%args);

	    my \$res = \$self->_request(
		path     => (\$id =~ /^\\s*\$/) ? '$name' : '$name'."/\$id",
		query    => \$query_params,
		);
	    
	    my \$json = JSON::XS::decode_json( \$res->decoded_content );
            my \$class_data = \$json->{resp}->{'$name'};
            \$class_data->{_uri} = \$res->base;
            \$class_data->{_params} = \$query_params;
            \$class_data->{_base} = '$name';

	    if (\$json->{resp}->{status} == JSON::XS::true && defined \$json->{resp}->{'$name'}) {
		return $pkg->new(\%{\$class_data});	
	    }

            return undef;
	}
	
	package $pkg;
	sub new {
	    my (\$class, \%args) = \@_;
	    my \$self = bless \\\%args, \$class;

	    return \$self;
	}
	1;
    };

    croak "Cannot create namespace $name: $@\n" if not $namespace;
}

sub _get_query_params {
    my ($self, $name, %args) = @_;
    my %params = ();

    for (keys %args) {
	if (exists $query_params{$name}->{$_}) {
	    $params{$_} = $args{$_};
	} else {
	    delete $args{$_};
	}
    }

    %params = ( %{$query_params{$name}}, %params );

    return \%params;
}


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

=head2 search( q => $searchstring )

Returns a L<WWW::Discogs::Search> object.

=cut

=head2 release( id => $release_id )

Returns a L<WWW::Discogs::Release> object. You can get a $release_id from a search,
artist, or label.

=cut

=head2 artist( name => $artist_name )

Returns a L<WWW::Discogs::Artist> object. You can get the exact name of an artist
from a search result's title.

=cut

=head2 label( name => $label_name )

Returns a L<WWW::Discogs::Label> object. You can get the exact name of a label
from a search result's title.

=cut


sub _request {
    my ($self, %args) = @_;
    my $path  = $args{path};
    my $query = $args{query};
    
    my $uri = URI->new(
	$self->{'apiurl'},
	'http',
	);
    $uri->path($path);
    $uri->query_form($query) if keys %{$query};
    
    my $url = $uri->canonical->as_string;
    my $res = $self->{ua}->get($url);
    
    croak join("\n", "Request to $url failed: ", $res->status_line, Dumper($res))
	unless $res->is_success;
    
    return $res;
}

=head1 AUTHOR

Lee Aylward <lee@laylward.com>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
