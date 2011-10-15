package WWW::Discogs::Master;

use strict;
use warnings;
use NEXT;
use base qw ( WWW::Discogs::ReleaseBase );

=head1 NAME

WWW::Discogs::Master - get master release information and images

=cut

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

    $self->{_versions}     = $args{versions}     || [];
    $self->{_main_release} = $args{main_release} || '';

    return $self;
}

=head2 versions

returns list of versions

=cut
sub versions {
    my $self = shift;
    return @{ $self->{_versions} };
}

=head2 main_release

returns Discogs ID of the main release

=cut
sub main_release {
    my $self = shift;
    return $self->{_main_release};
}

=head2 tracklist

In list context returns a list of tracks.
In scalar context returns a formatted tracklist string of the main release.

=cut
sub tracklist {
    my $self = shift;

    if (!wantarray) {
        my $tracklist;
        foreach my $track (@{ $self->{_tracklist} }) {
            $tracklist .= sprintf(
                "%s\n",
                join("\t",
                     $track->{title},
                     $track->{duration}
                ));
        }
        return $tracklist;
    }

    return @{ $self->{_tracklist} };
}

1;
