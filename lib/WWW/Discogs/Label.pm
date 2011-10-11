package WWW::Discogs::Label;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Label - get music label information and images

=head1 METHODS

=cut

=head2 name

returns the name

=cut
sub name {
    my $self = shift;
    return $self->{name};
}

=head2 releases

returns a list of releases

=cut
sub releases {
    my $self = shift;
    return @{ $self->{releases} };
}

=head2 images

Returns a list of images

=cut
sub images {
    my ($self, %args) = @_;
    my $image_type = $args{type};

    if ($image_type) {
	return grep { $_->{type} =~ /^${image_type}$/i } @{ $self->{images} };
    }
    
    return @{ $self->{images} };
}

=head2 contactinfo

returns a blurb of contact info

=cut
sub contactinfo {
    my $self = shift;
    return $self->{contactinfo};
}

=head2 sublabels

returns a list of sublabel names

=cut
sub sublabels {
    my $self = shift;
    return @{ $self->{sublabels} };
}

=head2 parentlabel

returns parent label's name

=cut
sub parentlabel {
    my $self = shift;
    return $self->{parentLabel};
}

1;
