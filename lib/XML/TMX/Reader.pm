package XML::TMX::Reader;

use 5.004;
use warnings;
use strict;
use Exporter ();
use vars qw($VERSION @ISA @EXPORT_OK);

use XML::DT;

$VERSION = '0.2';
@ISA = 'Exporter';
@EXPORT_OK = qw();

=head1 NAME

XML::TMX::Reader - Perl extension for reading TMX files

=head1 SYNOPSIS

   use XML::TMX::Reader;

   my $reader = XML::TMX::Reader->new( $filename );

   $reader -> for_tu( sub {
       my $tu = shift;
       #blah blah blah
   });

   @used_languages = $reader->languages;

=head1 DESCRIPTION

This module provides a simple way for reading TMX files.

=head1 METHODS

The following methods are available:

=head2 new

This method creates a new XML::TMX::Reader object. This process checks
for the existence of the file and extracts some meta-information from
the TMX header;

  my $reader = XML::TMX::Reader->new("my.tmx");

=cut

sub new {
  my $class = shift;
  my $file = shift;

  # Here we should parse the header and store some (important/useful)
  # information

  return undef unless -f $file;

  my $self = {
	      filename => $file,
	      ignore_markup => 1,
	     };

  return bless $self, $class;
}

=head2 ignore_markup

This method is used to set the flag to ignore (or not) markup inside
translation unit segmnets. The default is to ignore those markup.

If called without parameters, it sets the flag to ignore the
markup. If you don't want to do that, use

  $reader->ignore_markup(0);

=cut

sub ignore_markup {
  my $self = shift;
  my $opt = shift || 1;
  $self->{ignore_markup} = $opt;
}

=head2 languages

This method returns the languages being used on the specified
translation memory. Note that the module does not check for language
code correctness or existence.

=cut

sub languages {
  my $self = shift;
  my %languages = ();
  $self->for_tu( sub{ my $tu = shift; $languages{$_}++ for keys %$tu } );
  return keys %languages;
}

=head2 for_tu

Use C<for_tu> to process all translation units from a TMX file. The
first (and unique) argument to this method is a code reference. This
code will be called for each translation unit found.

The function will receive two arguments:

=over

=item *

a reference to a hash which maps language codes to the respective
translation unit segment;

=item *

a reference to a hash which contains the attributes for those
translation unit tag;

=back

=cut

sub for_tu {
  my $self = shift;
  my $code = shift;

  my %handler = ( -type => { tu => 'SEQ' },
		  tu  => sub {
		    my %tu = map { ( $_->[0] => $_->[1] ) } @$c;
		    &{$code}(\%tu,\%v);
		  },
		  tuv => sub { [$v{lang} || $v{'xml:lang'}, $c] },
		  seg => sub { $c },
		  body => sub { $c },
		  tmx => sub { $c },
		  hi => sub { $self->{ignore_markup}?$c:toxml },
		  ph => sub { $self->{ignore_markup}?$c:toxml },
		);

  dt($self->{filename}, %handler);
}

=head2 to_html

Use this method to create a nice HTML file with the translation
memories. Notice that this method is not finished yet, and relies on
some images, on some specific locations.

=cut

sub to_html {
  my $self = shift;
  my %opt = @_;
  $self->for_tu(sub {
		  my ($langs, $opts) = @_;
		  my $ret = "<table>";
		  for (keys %$langs) {
		    $ret .= "<tr><td style=\"vertical-align: top\">";
		    if ($opt{icons}) {
		      $ret .= "<img src=\"/icons/flags/".lc($_).".png\" alt=\"$_\"/>"
		    } else {
		      $ret .= "$_"
		    }
		    $ret .= "</td><td>$langs->{$_}</td></tr>\n"
		  }
		  $ret .= "<tr><td></td><td><div style=\"font-size: small; color: #999;\">";
		  for (keys %$opts) {
		    $ret .= "$_: $opts->{$_} &nbsp;&nbsp; "
		  }
		  $ret .= "</div></td></tr></table>";
		  $ret;
		});
}


=head1 SEE ALSO

L<XML::Writer(3)>, TMX Specification L<http://www.lisa.org/tmx/tmx.htm>

=head1 AUTHOR

Alberto Simões, E<lt>albie@alfarrabio.di.uminho.ptE<gt>

Paulo Jorge Jesus Silva, E<lt>paulojjs@bragatel.ptE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Projecto Natura

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
