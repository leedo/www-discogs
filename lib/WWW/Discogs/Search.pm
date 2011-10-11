package WWW::Discogs::Search;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Search

=cut

=head1 METHODS

=cut

=head2 exactresults

returns a list of results that matched exactly

=cut
sub exactresults {
    my $self = shift;
    return @{ $self->{exactresults} };
}

=head2 searchresults

returns a list of normal search results

=cut
sub searchresults {
    my $self = shift;
    return @{ $self->{searchresults}->{results} };
}

=head2 numresults

returns the number of results found

=cut
sub numresults {
    my $self = shift;
    return $self->{searchresults}->{numResults};
}

=head2 pages

returns the number of pages in search results

=cut
sub pages {
    my $self = shift;
    if (!$self->num_results) {
        return 0;
    }
    return int($self->num_results / 20) + 1;
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

=head2 url

returns url of search

=cut
sub url {
    my $self = shift;
    return $self->{_uri};
}

1;
