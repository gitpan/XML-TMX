package XML::TMX::Writer;
# vim:sw=3:ts=3:et:

use 5.004;
use warnings;
use strict;
use Exporter ();
use vars qw($VERSION @ISA @EXPORT_OK);

$VERSION = '0.2';
@ISA = 'Exporter';
@EXPORT_OK = qw(&new);

=pod
=head1 NAME

XML::TMX::Writer - Perl extension for writing TMX files

=head1 SYNOPSIS

   use XML::TMX::Writer;

   my $tmx = new XML::TMX::Writer();

   $tmx->start_tmx(ID => 'paulojjs');

   $tmx->add_tu(SRCLANG => 'en', 'en' => 'some text', 'pt' => 'algum texto');

   $tmx->end_tmx();

=head1 DESCRIPTION

This module provides a simple way for writing TMX files.

=head1 METHODS

The following methods are available:

=over

=item $tmx = B<new> XML::TMX::Writer();

Creates a new XML::TMX::Writer object

=cut
sub new {
   my $proto = shift();
   my $class = ref($proto) || $proto;
   my $self = {};
   
   bless($self, $class);
   return($self);
}

=pod

=item $tmx->B<start_tmx>(OUTPUT => 'F<some_file.tmx>');

Begins a TMX file. Several options are available:

=over 8

=cut
sub start_tmx {
   my $self = shift(); 
   my %options = @_;
   my %o;
   
   # for creationdate -> perldoc -f gmtime
   my @time = gmtime(time);
   $o{'creationdate'} = sprintf("%d%02d%02dT%02d%02d%02dZ", $time[5]+1900,
                      $time[4]+1, $time[3], $time[2], $time[1], $time[0]);

=pod

=item OUTPUT

Output of the TMX, if none is defined stdout is used by default.

=cut
   if(exists($options{OUTPUT})) {
     open $self->{OUTPUT}, ">$options{OUTPUT}" or die "Cannot open file '$options{OUTPUT}': $!\n";
     # $self->{OUTPUT} = new IO::File(">$options{OUTPUT}");
     #$self->{XML} = new XML::Writer(NEWLINES => 1, OUTPUT => $self->{OUTPUT});
   } else {
     $self->{OUTPUT} = \*STDOUT;
     #$self->{XML} = new XML::Writer(NEWLINES => 1);
   }
   #$self->{XML}->xmlDecl("UTF-8");
   my $encoding = $options{ENCODING} || "UTF-8";
   $self->Write("<?xml version=\"1.0\" encoding=\"$encoding\$?>");

=pod

=item TOOL

Tool used to create the TMX. Defaults to 'XML::TMX::Writer'

=cut
   $o{'creationtool'} = $options{TOOL} || 'XML::TMX::Writer';

=pod

=item TOOLVERSION

Some version identification of the tool used to create the TMX. Defaults
to the current module version

=cut
   $o{'creationtoolversion'} = $options{TOOLVERSION} || $VERSION;

=pod

=item SEGTYPE

Segment type used in the I<E<lt>tuE<gt>> elements. Possible values are I<block>,
I<paragraph>, I<sentence> and I<phrase>. Defaults to I<sentence>.

=cut
   if(defined($options{SEGTYPE}) && ($options{SEGTYPE} eq 'block' ||
        $options{SEGTYPE} eq 'paragraph' || $options{SEGTYPE} eq 'sentence' ||
        $options{SEGTYPE} eq 'phrase')) {
      $o{'segtype'} = $options{SEGTYPE};
   } else {
      $o{'segtype'} = 'sentence'
   }

=pod

=item SRCTMF

Specifies the format of the translation memory file from which the TMX document or
segment thereof have been generated.

=cut
   $o{'o-tmf'} = $options{SRCTMF} || 'plain text';

=pod

=item ADMINLANG

Specifies the default language for the administrative and informative
elements I<E<lt>noteE<gt>> and I<E<lt>propE<gt>>.

=cut
   $o{'adminlang'} = $options{ADMINLANG} || 'en';

=pod

=item SRCLANG

Specifies the language of the source text. If a I<E<lt>tuE<gt>> element does
not have a srclang attribute specified, it uses the one defined in the
I<E<lt>headerE<gt>> element. Defaults to I<*all*>.

=cut
   $o{'srclang'} = $options{SRCLANG} || '*all*';

=pod

=item DATATYPE

Specifies the type of data contained in the element. Depending on that
type, you may apply different processes to the data.

The recommended values for the datatype attribute are as follow (this list is
not exhaustive):

=over

=item unknown

undefined

=item alptext

WinJoust data

=item cdf

Channel Definition Format

=item cmx

Corel CMX Format

=item cpp

C and C++ style text

=item hptag

HP-Tag

=item html

HTML, DHTML, etc

=item interleaf

Interleaf documents

=item ipf

IPF/BookMaster

=item java

Java, source and property files

=item javascript

JavaScript, ECMAScript scripts

=item lisp

Lisp

=item mif

Framemaker MIF, MML, etc

=item opentag

OpenTag data

=item pascal

Pascal, Delphi style text

=item plaintext

Plain text (default)

=item pm

PageMaker

=item rtf

Rich Text Format
=item sgml

SGML

=item stf-f

S-Tagger for FrameMaker

=item stf-i

S-Tagger for Interleaf

=item transit

Transit data

=item vbscript

Visual Basic scripts

=item winres

Windows resources from RC, DLL, EXE

=item xml

XML

=item xptag

Quark XPressTag

=back

=cut
   $o{'datatype'} = $options{DATATYPE} || 'plaintext';

=pod

=item SRCENCODING

All TMX documents are in Unicode. However, it is sometimes useful to know
what code set was used to encode text that was converted to Unicode for
purposes of interchange. This option specifies the original or preferred
code set of the data of the element in case it is to be re-encoded in a
non-Unicode code set. Defaults to none.

=cut
   if(defined($options{SRCENCODING})) { $o{'o-encoding'} = $options{SRCENCODING}; }


=pod

=item ID

Specifies the identifier of the user who created the element. Defaults to none.

=cut
   if(defined($options{ID})) { $o{'creationid'} = $options{ID}; }

   $self->startTag('tmx', 'version' => 1.4);
   $self->startTag('header', %o);
   $self->startTag('body', 'version' => 1.4);
}

=pod

=back

=item $tmx->B<add_tu>(SRCLANG => LANG1, LANG1 => 'text1', LANG2 => 'text2');

Adds a translation unit to the TMX file. Several optional labels can be
specified:

=over

=cut
sub add_tu {
   my $self = shift;
   my %tuv = @_;
   my %opt;

=pod

=item ID

Specifies an identifier for the I<E<lt>tuE<gt>> element. Its value is not
defined by the standard (it could be unique or not, numeric or
alphanumeric, etc.).

=cut
   if(defined($tuv{ID})) {
      $opt{'tuid'} = $tuv{ID};
      delete($tuv{ID});
   }
   
=pod

=item SRCENCODING

Same meaning as told in B<start_tmx> method.

=cut
   if(defined($tuv{SRCENCODING})) {
      $opt{'o-encoding'} = $tuv{SRCENCODING};
      delete($tuv{SRCENCODING});
   }
   
=pod

=item DATATYPE

Same meaning as told in B<start_tmx> method.

=cut
   if(defined($tuv{DATATYPE})) {
      $opt{'datatype'} = $tuv{DATATYPE};
      delete($tuv{DATATYPE});
   }
   
=pod

=item SEGTYPE

Same meaning as told in B<start_tmx> method.

=cut
   if(defined($tuv{SEGTYPE})) {
      $opt{'segtype'} = $tuv{SEGTYPE};
      delete($tuv{SEGTYPE});
   }
   
=pod

=item SRCLANG

Same meaning as told in B<start_tmx> method.

=cut
   if(defined($tuv{SRCLANG})) {
      $opt{'srclang'} = $tuv{SRCLANG};
      delete($tuv{SRCLANG});
   }
   
   $self->startTag('tu', %opt);
   for my $lang (keys %tuv) {
      $self->startTag('tuv', 'xml:lang' => $lang);
      $self->startTag('seg');
      $self->characters($tuv{$lang});
      $self->endTag('seg');
      $self->endTag('tuv');
   }
   $self->endTag('tu');
}

=pod

=back

=item $tmx->B<end_tmx>();

Ends the TMX file, closing file handles if necessary.

=back

=cut
sub end_tmx {
   my $self = shift();
   $self->endTag('body');
   $self->endTag('tmx');
   #$self->{XML}->end();
   #$self->{OUTPUT}->close() if(defined($self->{OUTPUT}));
   close($self->{OUTPUT});
}

=pod

=head1 HISTORY

=over 8

=item 0.1

Original version; provides methods: new, start_tmx and end_tmx

=back

=head1 SEE ALSO

TMX Specification L<http://www.lisa.org/tmx/tmx.htm>

=head1 AUTHOR

Paulo Jorge Jesus Silva, E<lt>paulojjs@bragatel.ptE<gt>
Alberto Simões, E<lt>albie@alfarrabio.di.uminho.ptE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Projecto Natura

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub Write {
  my $self = shift;
  print {$self->{OUTPUT}} @_, "\n";
}

sub startTag {
  my $self = shift;
  my $tagName = shift;
  my %attributes = @_;
  my $attributes = "";
  $attributes = " ".join(" ",map {"$_=\"$attributes{$_}\""} keys %attributes) if %attributes;
  $self->Write("<$tagName$attributes>");
}

sub characters {
  my $self = shift;
  my $text = shift;
  $text =~ s/\&/\&amp;/g;
  $text =~ s/</\&lt;/g;
  $text =~ s/>/\&gt;/g;
  $text =~ s/\n$//g;
  $self->Write($text);
}

sub endTag {
  my $self = shift;
  my $tagName = shift;
  $self->Write("</$tagName>");
}

1;


