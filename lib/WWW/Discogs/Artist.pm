package WWW::Discogs::Artist;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Artist - get musician information and images

=cut

=head1 METHODS

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

    $self->{_name}           = $args{name}           || '';
    $self->{_realname}       = $args{realname}       || '';
    $self->{_profile}        = $args{profile}        || '';
    $self->{_aliases}        = $args{aliases}        || [];
    $self->{_namevariations} = $args{namevariations} || [];
    $self->{_urls}           = $args{urls}           || [];
    $self->{_releases}       = $args{releases}       || [];
    $self->{_images}         = $args{images}         || [];
    $self->{_params}         = $args{_params}        || {};
    $self->{_uri}            = $args{_uri}           || '';

    return $self;
}

=head2 name

returns the name of the artist

=cut
sub name {
    my $self = shift;
    return $self->{_name};
}

=head2 realname

returns realname of the artist

=cut
sub realname {
    my $self = shift;
    return $self->{_realname};
}

=head2 aliases

returns a list of aliases

=cut
sub aliases {
    my $self = shift;
    return @{ $self->{_aliases} };
}


=head2 namevariations

returns a list of name variations

=cut
sub namevariations {
    my $self = shift;
    return @{ $self->{_namevariations} };
}

=head2 profile

returns artist profile

=cut
sub profile {
    my $self = shift;
    return $self->{_profile};
}

=head2 urls

returns a list of urls

=cut
sub urls {
    my $self = shift;
    return @{ $self->{_urls} };
}

=head2 releases

returns a list of releases

=cut
sub releases {
    my $self = shift;
    return @{ $self->{_releases} };
}

=head2 images

returns a list of images.

=cut
sub images {
    my ($self, %args) = @_;
    my $image_type = $args{type};

    if ($image_type) {
        return grep { $_->{type} =~ /^${image_type}$/i } @{ $self->{_images} };
    }

    return @{ $self->{_images} };
}

1;
