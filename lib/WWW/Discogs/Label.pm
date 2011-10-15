package WWW::Discogs::Label;

use strict;
use warnings;
use NEXT;
use base qw( WWW::Discogs::HasMedia );

=head1 NAME

WWW::Discogs::Label - get music label information and images

=head1 METHODS

=cut

sub new {
    my ($class, @args) = @_;

    my $self = {};
    bless $self, $class;
    $self->EVERY::LAST::_init(@args);

    return $self;
}

sub _init {
    my ($self, %args) = @_;

    $self->{_name}        = $args{name}        || '';
    $self->{_contactinfo} = $args{contactinfo} || '';
    $self->{_parentLabel} = $args{parentLabel} || '';
    $self->{_releases}    = $args{releases}    || [];
    $self->{_sublabels}   = $args{sublabels}   || [];
    $self->{_params}      = $args{_params}     || {};
    $self->{_uri}         = $args{_uri}        || '';

    return $self;
}

=head2 name

returns the name

=cut
sub name {
    my $self = shift;
    return $self->{_name};
}

=head2 releases

returns a list of releases

=cut
sub releases {
    my $self = shift;
    return @{ $self->{_releases} };
}

=head2 contactinfo

returns a blurb of contact info

=cut
sub contactinfo {
    my $self = shift;
    return $self->{_contactinfo};
}

=head2 sublabels

returns a list of sublabel names

=cut
sub sublabels {
    my $self = shift;
    return @{ $self->{_sublabels} };
}

=head2 parentlabel

returns parent label's name

=cut
sub parentlabel {
    my $self = shift;
    return $self->{_parentLabel};
}

1;
