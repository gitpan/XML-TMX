# -*- cperl -*-
use Data::Dumper;
use Test::More tests => 10;

BEGIN {
  use_ok(XML::TMX::Reader);
};

my $reader;

$reader = XML::TMX::Reader->new('foobar.tmx');
ok(!$reader,"rigth foobar.tmx is not present");

$reader = XML::TMX::Reader->new('t/sample.tmx');
ok($reader, "reading sample.tmx");

my $count = 0;
$reader->for_tu( sub {
		   my $tu = shift;
		   $count++;
		 });

is($count, 7, "counting tu's with for_tu");

$count = 0;
$reader->for_tu2( sub {
		   my $tu = shift;
		   $count++;
		 });
is($count, 7,"counting tu's with for_tu2");

$reader->for_tu2( {output => "t/_tmp.tmx", },
                  sub {
		   my $tu = shift;
                   $tu->{-prop}={q=>77, aut=>"jj"};
                   $tu->{-note}=[2..5];
                   $tu;
		 });

ok( -f "t/_tmp.tmx");

$reader = XML::TMX::Reader->new('t/_tmp.tmx');
ok($reader,"loadind t/_tmp.tmx");

$reader->for_tu2( {output => "t/_tmp2.tmx", },
                  sub {
                   my $tu = shift;
                   for (keys %{$tu->{-prop}}){
                     $tu->{-prop}{$_} .= "batatas";  
                   } 
                   for (@{$tu->{-note}}){
                     $_ = "$_ cabolas"
                   }
                   $tu;
                 });

my @langs = $reader->languages;

is(@langs, 2 , "languages".join(",",@langs));

ok(grep { $_ eq "EN-GB" } @langs, "en");
ok(grep { $_ eq "PT-PT" } @langs, "pt");
unlink( "t/_tmp.tmx");
unlink( "t/_tmp2.tmx");
