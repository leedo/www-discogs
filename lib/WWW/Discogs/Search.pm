package WWW::Discogs::Search;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Search

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

    $self->{_exactresults}                 = $args{exactresults}                || [];
    $self->{_searchresults}->{_results}    = $args{searchresults}->{results}    || [];
    $self->{_searchresults}->{_numresults} = $args{searchresults}->{numResults} || '';
    $self->{_searchresults}->{_start}      = $args{searchresults}->{start}      || '';
    $self->{_searchresults}->{_end}        = $args{searchresults}->{end}        || '';
    $self->{_params}                       = $args{_params}                     || {};
    $self->{_uri}                          = $args{_uri}                        || '';

    return $self;
}

=head2 exactresults

returns a list of results that matched exactly

=cut
sub exactresults {
    my $self = shift;
    return @{ $self->{_exactresults} };
}

=head2 searchresults

returns a list of normal search results

=cut
sub searchresults {
    my $self = shift;
    return @{ $self->{_searchresults}->{results} };
}

=head2 numresults

returns the number of results found

=cut
sub numresults {
    my $self = shift;
    return $self->{_searchresults}->{_numresults};
}

=head2 pages

returns the number of pages in search results

=cut
sub pages {
    my $self = shift;
    if (!$self->numresults) {
        return 0;
    }
    return int($self->numresults / 20) + 1;
}

=head2 query

returns the search query

=cut
sub query {
    my $self = shift;
    return $self->{_params}->{q};
}

=head2 type

returns search type

=cut
sub type {
    my $self = shift;
    return $self->{_params}->{type};
}

=head2 page

returns search results' page number

=cut
sub page {
    my $self = shift;
    return $self->{_params}->{page};
}

1;
