package WWW::Discogs::Search;

use strict;
use warnings;

sub new {
	my ($class, %opts) = @_;
	bless \%opts, $class;
}

=head1 NAME

WWW::Discogs::Search

=cut

=head1 METHODS

=cut

=head2 exactresults

returns an list of results that matched exactly

=cut
sub exactresults {
	my $self = shift;
	return @{ $self->{exactresults}{result} };
}

=head2 searchresults

returns an list of normal search results

=cut
sub searchresults {
	my $self = shift;
	return @{ $self->{searchresults}{result} };
}

1;
