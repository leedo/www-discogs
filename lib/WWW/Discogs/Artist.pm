package WWW::Discogs::Artist;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Artist - get musician information and images

=cut

=head1 METHODS

=cut

=head2 name

returns the name of the artist

=cut
sub name {
    my $self = shift;
    return $self->{name};
}

=head2 realname

returns realname of the artist

=cut
sub realname {
    my $self = shift;
    return $self->{realname};
}

=head2 aliases

returns a list of aliases

=cut
sub aliases {
    my $self = shift;
    return @{ $self->{aliases} };
}


=head2 namevariations

returns a list of name variations

=cut
sub namevariations {
    my $self = shift;
    return @{ $self->{namevariations} };
}

=head2 profile

returns artist profile

=cut
sub profile {
    my $self = shift;
    return $self->{profile};
}

=head2 urls

returns a list of urls

=cut
sub urls {
    my $self = shift;
    return @{ $self->{urls} };
}

=head2 releases

returns a list of releases

=cut
sub releases {
    my $self = shift;
    return @{ $self->{releases} };
}

=head2 images

returns a list of images.

=cut
sub images {
    my ($self, %args) = @_;
    my $image_type = $args{type};

    if ($image_type) {
        return grep { $_->{type} =~ /^${image_type}$/i } @{ $self->{images} };
    }

    return @{ $self->{images} };
}

1;
