package WWW::Discogs::Release;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Release - get music release information and images

=head1 METHODS

=cut

=head2 title

returns the title

=cut
sub title {
    my $self = shift;
    return $self->{title};
}

=head2 artists

returns a list of artist names

=cut
sub artists {
    my $self = shift;
    return @{ $self->{artists} };
}

=head2 styles

returns a list of styles

=cut
sub styles {
    my $self = shift;
    return @{ $self->{styles} };
}

=head2 released

returns the date

=cut
sub released {
    my $self = shift;
    return $self->{released};
}

=head2 released_formatted

returns released_formatted

=cut
sub released_formatted {
    my $self = shift;
    return $self->{released_formatted};
}

=head2 tracklist

In list context returns a list of tracks. In scalar context returns a formatted tracklist string.

=cut
sub tracklist {
    my ($self) = shift;

    if (!wantarray) {
	my $tracklist;
	foreach my $track (@{ $self->{tracklist} }) {
	    $tracklist .= sprintf("%s\n", join("\t", $track->{position}, $track->{title}, $track->{duration}));
	}
	return $tracklist;
    }

    return @{ $self->{tracklist} };
}

=head2 extraartists

returns a list of artists

=cut
sub extraartists {
    my $self = shift;
    return @{ $self->{extraartists} };
}

=head2 genres

returns a list of genre names

=cut
sub genres {
    my $self = shift;
    return @{ $self->{genres} };
}

=head2 labels

returns a list of labels

=cut
sub labels {
    my $self = shift;
    return @{ $self->{labels} };
}


=head2 country

Returns the country

=cut
sub country {
    my $self = shift;
    return $self->{country};
}

=head2 formats

returns a list of formats

=cut
sub formats {
    my $self = shift;
    return @{ $self->{formats} };
}

=head2 id

returns the discogs ID for the album

=cut
sub id {
    my $self = shift;
    return $self->{id};
}

=head2 notes

returns release notes

=cut
sub notes {
    my $self = shift;
    return $self->{notes};
}

=head2 status

returns status

=cut
sub status {
    my $self = shift;
    return $self->{status};
}

=head2 videos

returns list of videos

=cut
sub videos {
    my $self = shift;
    return @{ $self->{videos} };
}

=head2 year

returns year

=cut
sub year {
    my $self = shift;
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

=head2 master_id

returns master_id

=cut
sub master_id {
    my $self = shift;
    return $self->{master_id};
}

1;
