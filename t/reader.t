# -*- cperl -*-
use Data::Dumper;
use Test::More tests => 7;

BEGIN {
  use_ok(XML::TMX::Reader);
};

my $reader;

$reader = XML::TMX::Reader->new('foobar.tmx');
ok(!$reader);

$reader = XML::TMX::Reader->new('t/sample.tmx');
ok($reader);

my $count = 0;
$reader->for_tu( sub {
		   my $tu = shift;
		   $count++;
		 });

is($count, 7);

my @langs = $reader->languages;

is(@langs, 2);

ok(grep { $_ eq "EN-GB" } @langs);
ok(grep { $_ eq "PT-PT" } @langs);
