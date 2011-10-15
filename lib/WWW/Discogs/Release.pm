package WWW::Discogs::Release;

use strict;
use warnings;
use NEXT;
use base qw( WWW::Discogs::ReleaseBase );

=head1 NAME

WWW::Discogs::Release - get music release information and images

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

    $self->{_title}        = $args{title}              || '';
    $self->{_released}     = $args{released}           || '';
    $self->{_released_fmt} = $args{released_formatted} || '';
    $self->{_country}      = $args{country}            || '';
    $self->{_status}       = $args{status}             || '';
    $self->{_master_id}    = $args{master_id}          || '';
    $self->{_formats}      = $args{formats}            || [];
    $self->{_labels}       = $args{labels}             || [];

    return $self;
}

=head2 title

returns the title

=cut
sub title {
    my $self = shift;
    return $self->{_title};
}

=head2 released

returns the date

=cut
sub released {
    my $self = shift;
    return $self->{_released};
}

=head2 released_formatted

returns released_formatted

=cut
sub released_formatted {
    my $self = shift;
    return $self->{_released_fmt};
}

=head2 tracklist

In list context returns a list of tracks.
In scalar context returns a formatted tracklist string.

=cut
sub tracklist {
    my ($self) = shift;

    if (!wantarray) {
        my $tracklist;
        foreach my $track (@{ $self->{_tracklist} }) {
            $tracklist .= sprintf(
                "%s\n",
                join(
                    "\t",
                    $track->{position},
                    $track->{title},
                    $track->{duration},
                ));
        }
        return $tracklist;
    }

    return @{ $self->{_tracklist} };
}

=head2 labels

returns a list of labels

=cut
sub labels {
    my $self = shift;
    return @{ $self->{_labels} };
}


=head2 country

Returns the country

=cut
sub country {
    my $self = shift;
    return $self->{_country};
}

=head2 formats

returns a list of formats

=cut
sub formats {
    my $self = shift;
    return @{ $self->{_formats} };
}

=head2 status

returns status

=cut
sub status {
    my $self = shift;
    return $self->{_status};
}

=head2 master_id

returns master_id

=cut
sub master_id {
    my $self = shift;
    return $self->{_master_id};
}

1;
