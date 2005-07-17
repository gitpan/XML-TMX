# -*- cperl -*-

use Test::More tests => 4;

BEGIN {
  use_ok(XML::TMX::Writer);
};

my $tmx = new XML::TMX::Writer();

isa_ok($tmx, "XML::TMX::Writer");

$tmx->start_tmx(ID => "foobar", OUTPUT => "_${$}_");

$tmx->add_tu(SRCLANG => 'en',
	     'en' => 'some text',
	     'pt' => 'algum texto');

$tmx->end_tmx();

ok(-f "_${$}_");

ok(file_contents_almost_identical("t/writer1.xml", "_${$}_", 3));

unlink "_${$}_";


sub file_contents_almost_identical {
  my ($file1, $file2, @ilines) = @_;

  return 0 unless -f $file1;
  return 0 unless -f $file2;

  my $line = 0;

  open F1, $file1 or die;
  open F2, $file2 or die;

  my ($l1,$l2);

  while (defined($l1 = <F1>) && defined($l2 = <F2>)) {
    ++$line;
    next if grep {$_ eq $line} @ilines;
    return 0 unless $l1 eq $l2;
  }

  return 0 if <F1>;
  return 0 if <F2>;

  return 1;
}
