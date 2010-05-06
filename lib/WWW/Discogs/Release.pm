package WWW::Discogs::Release;

use strict;
use warnings;

=head1 NAME

WWW::Discogs::Release - get music release information and images

=head1 METHODS

=cut

sub new {
	my ($class, %opts) = @_;
	bless \%opts, $class;
}

=head2 title

returns the title

=cut
sub title {
	my $self = shift;
	return $self->{title};
}

=head2 artists

returns an list of artist names

=cut
sub artists {
	my $self = shift;
	return @{ $self->{artists}{artist} };
}


=head2 images

Returns an list of images

=cut
sub images {
	my $self = shift;
	return @{ $self->{images}{image} };
}

=head2 primary_images

Returns an list of the primary images

=cut
sub primary_images {
	my $self = shift;
	return grep {$_->{type} eq 'primary'} @{$self->{images}{image}};
}

=head2 secondary_images

returns an list of the secondary images

=cut
sub secondary_images {
	my $self = shift;
	return grep {$_->{type} eq 'secondary'} @{$self->{images}{image}};
}

=head2 styles

returns an list of styles

=cut
sub styles {
	my $self = shift;
	if($self->{styles}{style} && ref($self->{styles}{style}) eq 'ARRAY')
	{
		return @{ $self->{styles}{style} };	
	}
	else
	{
		return $self->{styles}{style};
	}

}

=head2 released

returns the date

=cut
#TODO make DateTime object
sub released {
	my $self = shift;
	return $self->{released};
}

=head2 tracklist

returns an list of tracks

=cut
sub tracklist {
	my $self = shift;
	return @{ $self->{tracklist}{track} };
}

=head2 extraartists

returns an list of artists

=cut
sub extraartists {
	my $self = shift;
	return @{ $self->{extraartists}{artist} };
}

=head2 genres

returns an list of genre names

=cut
sub genres {
	my $self = shift;
	return @{ $self->{genres}{genre} };
}

=head2 labels

returns an list of labels

=cut
sub labels {
	my $self = shift;
	return @{ $self->{labels}{label} };
}


=head2 country

Returns the country

=cut
sub country {
	my $self = shift;
	return $self->{country};
}

=head2 formats

returns an list of formats

=cut
sub formats {
	my $self = shift;
	return map {$_->{name}} @{$self->{formats}{format}};
}

=head2 id

returns the discogs ID for the album

=cut
sub id {
	my $self = shift;
	return $self->{id};
}

=head2 notes

returns an list of notes

=cut
sub notes {
	my $self = shift;
	return @{ $self->{notes} };
}

1;
