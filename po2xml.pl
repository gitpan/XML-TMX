#!/usr/bin/perl -w

use strict;
use lib 'lib';
use XML::TMX::FromPO;

my $tmx = new XML::TMX::FromPO(DEBUG => 1);

my %convert = ( 'pt_en' => 'pt en',
                'pt_es' => 'pt es',
                'pt_br' => 'pt pt_br',
                'en_fr' => 'en fr');
#               );

my $lang = '';
for my $c (keys %convert) {
   $lang = $lang . " $convert{$c}";
}

while(my $dir = shift()) {
      $tmx->parse_dir("$dir/po", LANG => $lang);
      $dir =~ m/([a-z0-9_\.-]+)\/*$/i;
      for my $conv (keys %convert) {
         open(XML, "|xmllint --format - | bzip2 > $1_$conv.tmx.bz2");
         *STDOUT = *XML;
         $tmx->create_tmx(LANG => "$convert{$conv}");
         close(XML);
      }
}
