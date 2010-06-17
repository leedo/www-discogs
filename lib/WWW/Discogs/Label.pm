package WWW::Discogs::Label;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Label - get music label information and images

=head1 METHODS

=cut


sub new {
	my ($class, %opts) = @_;
	bless \%opts, $class;
}

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
	return @{ $self->{releases}{release} };
}

=head2 images

Returns a list of images

=cut
sub images {
	my $self = shift;
	return @{ $self->{images}{image} };
}

=head2 primary_images

Returns a list of the primary images

=cut
sub primary_images {
	my $self = shift;
	return grep {$_->{type} eq 'primary'} @{$self->{images}{image}};
}

=head2 secondary_images

returns a list of the secondary images

=cut
sub secondary_images {
	my $self = shift;
	return grep {$_->{type} eq 'secondary'} @{$self->{images}{image}};
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
	return keys %{$self->{sublabels}};
}

1;
