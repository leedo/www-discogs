use inc::Module::Install;

name			'WWW-Discogs';
all_from		'lib/WWW/Discogs.pm';

requires		'LWP::UserAgent';
requires		'URI';
requires		'URI::Escape';
requires        'JSON::XS';
requires        'NEXT';

test_requires	'Test::More';
test_requires   'Test::Deep';
test_requires   'Test::Exception';
test_requires   'Test::Mock::LWP::Dispatch' => '0.03';
test_requires   'File::Slurp';
test_requires   'HTTP::Response';

no_index directory => 'requests';

WriteAll;
