package WWW::Discogs::Master;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Master - get master release information and images

=cut

=head1 METHODS

=cut

=head2 id

returns the ID of the master release

=cut

sub id {
    my ($self) = shift;
    return $self->{id};
}

=head2 styles

returns list of styles

=cut
sub styles {
    my ($self) = shift;
    return @{ $self->{styles} };
}

=head2 genres

returns list of genres

=cut
sub genres {
    my ($self) = shift;
    return @{ $self->{genres} };
}

=head2 videos

returns list of videos

=cut
sub videos {
    my ($self) = shift;
    return @{ $self->{videos} };
}

=head2 versions

returns list of versions

=cut
sub versions {
    my ($self) = shift;
    return @{ $self->{versions} };
}

=head2 main_release

returns Discogs ID of the main release

=cut
sub main_release {
    my ($self) = shift;
    return $self->{main_release};
}

=head2 notes

returns notes

=cut
sub notes {
    my ($self) = shift;
    return $self->{notes};
}

=head2 artists

returns list of artists

=cut
sub artists {
    my ($self) = shift;
    return @{ $self->{artists} };
}

=head2 year

returns year

=cut
sub year {
    my ($self) = shift;
    return $self->{year};
}

=head2 images

returns list of images

=cut
sub images {
    my ($self, %args) = @_;
    my $image_type = $args{type};

    if ($image_type) {
	return grep { $_->type =~ /^${image_type}$/i } @{ $self->{images} };
    }
    
    return @{ $self->{images} };
}

=head2 tracklist

In list context returns a list of tracks. 
In scalar context returns a formatted tracklist string of the main release.

=cut
sub tracklist {
    my ($self) = shift;

    if (!wantarray) {
	my $tracklist;
	foreach my $track (@{ $self->{tracklist} }) {
	    $tracklist .= sprintf("%s\n", join("\t", $track->{title}, $track->{duration}));
	}
	return $tracklist;
    }
    
    return @{ $self->{tracklist} };
}

1;
