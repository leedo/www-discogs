package WWW::Discogs;

use strict;
use warnings;

use LWP::UserAgent;
use URI;
use URI::Escape;
use Carp;
use JSON::XS;
use Data::Dumper;

use 5.008;
our $VERSION = '0.10';

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

            if (\$json->{resp}->{status} == JSON::XS::true &&
                defined \$json->{resp}->{'$name'}) {
                return $pkg->new(\%{\$class_data});
            }

            return undef;
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

    croak join(
        "\n",
        "Request to $url failed: ",
        $res->status_line, Dumper($res)
        ) unless $res->is_success;

    return $res;
}

1;
__END__

=head1 NAME

WWW::Discogs - get music related information and images

=cut

=head1 DESCRIPTION

Interface with www.discogs.com API to get music related information and
images. Discogs is a user-built database containing information on artists, 
labels, and their recordings.

=cut

=head1 SYNOPSIS

=head1 METHODS

=head2 search( q => $search_string )

=head2 search( q => $search_string, type => $search_type )

=head2 search( q => $search_string, type => $search_type, page => $page )

Returns a C<WWW::Discogs::Search> object. If you want to narrow down search
results then provide C<$search_type> which can be one of 'all' (the default),
'releases' (also returns masters), 'artists' or 'labels'.
Search results are paginated (20 results per page) and default is
C<< page => 1 >>. You can check how many search results pages are there by
calling C<pages> method on C<WWW::Discogs::Search> object.

=head2 release( id => $release_id )

Returns a C<WWW::Discogs::Release> object. You can get a $release_id from a
search, artist, or label.

=head2 master( id => $master_id )

Returns a C<WWW::Discogs::Master> object. You can get a $master_id from a
search or release.

=head2 artist( name => $artist_name )

=head2 artist( name => $artist_name, releases => 1 )

Returns a C<WWW::Discogs::Artist> object. You can get the exact name of an
artist from a search result's title.

=head2 label( name => $label_name )

=head2 label( name => $label_name, releases => 1 )

Returns a C<WWW::Discogs::Label> object. You can get the exact name of a label
from a search result's title.

=head1 OBJECTS CREATED AND THEIR METHODS

=head2 WWW::Discogs::Search

TODO: search example

=over

=item $search->exactresults

Returns list of hash references containing results exactly matching search
query.

=item $search->searchresults

Returns list of hash references containing search results.

=item $search->numresults

Returns a number of search results (counted without exact results).

=item $search->pages

Returns number of search results' pages. Each page contains max 20 search
results.

=back

=head2 WWW::Discogs::Release

=over

=item $release->id

Returns release ID.

=item $release->title

Returns title of the release.

=item $release->images

=item $release->images( type => $image_type )

Returns a list of hash references containing information about images for a
release. C< $image_type > can be one of 'primary' or 'secondary'. See example below:

  use WWW::Discogs;
  
  my $client = WWW::Discogs->new;
  my $release = $client->release(id => 797674);
  
  for my $img ( $release->images(type => 'primary') ) {
      printf("%3d x %3d - %s\n", $img->{width}, $img->{height}, $img->{uri});
  }

Prints:

  600 x 525 - http://api.discogs.com/image/R-797674-1309319643.jpeg

=item $release->released

Returns release date in ISO 8601 format (YYYY-MM-DD). 

=item $release->released_formatted

Returns formatted release date ('06 Oct 2006', 'Mar 2006' etc.)

=item $release->labels

Returns a list of hash references containing labels information.
See example below:

  use WWW::Discogs;
  
  my $client = WWW::Discogs->new;
  my $release = $client->release(id => 797674);
  
  for my $label ($release->labels) {
      printf("%s - %s\n", $label->{name}, $label->{catno});
  }

Prints:

  Poker Flat Recordings - PFRCD18
  Rough Trade Arvato - RTD 586.1018.2

=item $release->country

Returns country.

=item $release->formats

Returns a list of hash references containing formats information.
See example below:

  use WWW::Discogs;
  
  my $client = WWW::Discogs->new;
  my $release = $client->release(id => 797674);
  
  for my $format ($release->formats) {
      printf("%d x %s, %s\n",
             $format->{qty},
             $format->{name},
             join(", ", @{ $format->{descriptions } }),
          );
  }

Prints:

 1 x CD, Album, Partially Mixed
 1 x CD, Compilation, Limited Edition

=item $release->status

Returns status.

=item $release->master_id

Returns master release ID associated with a release. 

=item $release->year

Returns release year.

=item $release->notes

Returns release notes.

=item $release->styles

Returns a list of styles.

=item $release->genres

Returns a list of genres.

=item $release->artists

Returns a list of hash references containing artists information.

TODO: example

=item $release->extraartists

Returns a list of hash references containing extra artists information.

TODO: example

=item $release->tracklist

Returns tracklist.

TODO: document!

=back

=head2 WWW::Discogs::Master

=over

=item $master->id

Returns master ID.

=item $master->main_release

Returns main release ID.

=item $master->versions

Returns a list of hash references containing versions information. See example
below:

  use WWW::Discogs;
  
  my $client = WWW::Discogs->new;
  my $master = $client->master(id => 104330);
  
  for my $version ( $master->versions ) {
      printf("%9d %7s %15s %18s %7s %15s\n",
             $version->{id}, $version->{country}, $version->{title},
             $version->{format}, $version->{catno}, $version->{label});
  }


Prints:

   116934  Sweden   Chaos & Order          CD, Album  HPCD20 H. Productions
    11168  Sweden   Chaos & Order        2xLP, Album  HPLP20 H. Productions
  2307050  Sweden   Chaos & Order 2xLP, Album, W/Lbl  HPLP20 H. Productions

Other available keys in C<< $version >> besides the ones in example above are
C<< $version->{status} >> and C<< $version->{released} >>.

=item $master->images

=item $master->images( type => $image_type )

Returns a list of hash references containing information about images for
a release. C< $image_type > can be one of 'primary' or 'secondary'.
See example below:

  use WWW::Discogs;
  
  my $client = WWW::Discogs->new;
  my $master = $client->master(id => 23992);
  
  for my $img ( $master->images(type => 'primary') ) {
      printf("%3d x %3d - %s\n", $img->{width}, $img->{height}, $img->{uri});
  }

Prints:

  600 x 600 - http://api.discogs.com/image/R-830189-1265162680.jpeg

=item $master->year

Returns release year.

=item $master->notes

Returns release notes.

=item $master->styles

Returns a list of styles.

=item $master->genres

Returns a list of genres.

=item $master->artists

Returns a list of hash references containing artists information.

TODO: example

=item $master->extraartists

Returns a list of hash references containing extra artists information.

TODO: example

=item $master->tracklist

Returns tracklist.

TODO: document!

=back

=head2 WWW::Discogs::Artist

=over

=item $artist->name

Returns artist name.

=item $artist->realname

Returns artist's real name

=item $artist->aliases

Returns a list of aliases used by the artist.

=item $artist->namevariations

Returns a list of name variations for the artist.

=item $artist->profile

Returns artist's profile information.

=item $artist->urls

Returns a list of site's URLs linked to the artist.

=item $artist->releases

If $client->artist method creating a new C<WWW::Discogs::Artist> object was
called with C<< releases => 1 >> parameter you can get the list of artist's
releases by calling this method. The result will be a list of hash references
containing releases/master releases information. See example below:

  use WWW::Discogs;
  
  my $client = WWW::Discogs->new;
  my $artist = $client->artist(name => "Adam Beyer", releases => 1);
  
  foreach my $r ($artist->releases) {
    printf("%8d %7s %17s %s\n", $r->{id}, $r->{type}, $r->{role}, $r->{title});
  }

=over 4

=item *

C<< $r->{id} >> will contain release/master release ID

=item *

C<< $r->{type} >> will contain release type ('release' or 'master')

=item *

C<< $r->{role} >> will contain artist's role in release
('Main', 'Remix', 'Producer', 'Appearance', 'TrackAppearance' etc.)

=item *

C<< $r->{title} >> will contain release/master release title

=back

For releases with 'master' type you can get main release ID by checking the
value of C<< $r->{main_release} >>. Use C<Data::Dumper> to find out more about
this structure as results differ depending on artist's role and release type.

=back

=head2 WWW::Discogs::Label

=over

=item $label->name

Returns label's name.

=item $label->releases

If $client->label method creating a new C<WWW::Discogs::Label> object was
called with C<< releases => 1 >> parameter you can get the list of label's
releases by calling this method. The result will be a list of hash references
containing releases information. See example below:

  use WWW::Discogs;
  
  my $client = WWW::Discogs->new;
  my $label = $client->label(name => 'Southsoul Appendix', releases => 1);
  
  for my $r ($label->releases) {
      printf("%8d %11s %25s %10s %s\n", 
             $r->{id}, $r->{catno}, $r->{artist}, $r->{title}, $r->{format});
  }

Prints:

    31391 SUDAPPX 001               Markantonio Appendix A 12"
    31392 SUDAPPX 002          Davide Squillace Appendix B 12"
    33698 SUDAPPX 003              Marco Carola Appendix C 12"
    75142 SUDAPPX 004           Danilo Vigorito Appendix D 12"
  2281344 SUDAPPX 004           Danilo Vigorito Appendix D 12", W/Lbl, Sti
   176859 SUDAPPX 005     Adam Beyer & Henrik B Appendix E 12"
   332559 SUDAPPX 006           Carola Pisaturo Appendix F 12"

=item $label->contactinfo

Returns contact info to the label.

=item $label->sublabels

Returns a list containing names of sublabels.

=item $label->parentlabel

Returns the name of parent label.

=back

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
