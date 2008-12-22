package XML::TMX;
# vim:sw=3:ts=3:et:

use 5.004;
use warnings;
use strict;
use Exporter ();
use vars qw($VERSION @ISA @EXPORT_OK);

$VERSION = '0.17';
@ISA = 'Exporter';
@EXPORT_OK = qw();

=head1 NAME

XML::TMX - Perl extensions for managing TMX files

=head1 SYNOPSIS

   use XML::TMX;

=head1 DESCRIPTION

XML::TMX is the top level module. At the moment it does not contain
any useful code, so check sub-modules, please.


=head1 SEE ALSO

XML::TMX::Writer, XML::TMX::Reader, XML::TMX::Query, XML::TMX::FromPO

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
