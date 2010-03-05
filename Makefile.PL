use inc::Module::Install;

name			'WWW-Discogs';
all_from		'lib/WWW/Discogs.pm';

requires		'LWP::UserAgent';
requires		'URI';
requires		'XML::Simple';

test_requires	'Test::More';

WriteAll;
