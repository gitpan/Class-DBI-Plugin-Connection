package Class::DBI::Plugin::Connection;
use strict;
use warnings;
use Carp;

use vars '$VERSION';

$VERSION = 0.01;

sub import {
	my $class = shift;
	my $pkg   = caller(0);
	unless($pkg->isa('Class::DBI')){
		croak(__PACKAGE__." is for Clas::DBI application.");
	}
	$pkg->mk_classdata('connection_caching');
	$pkg->connection_caching($ENV{MOD_PERL} ? 0 : 1);
	no strict 'refs';
	*{$pkg."::_mk_db_closure"} = sub {
		my($class, @connection) = @_;
		my $dbh;
		return sub {
			unless ($dbh && $dbh->FETCH('Active') && $dbh->ping){
				$dbh = $class->connection_caching
					? DBI->connect_cached(@connection)
					: DBI->connect(@connection);
			}
			return $dbh;
		};
	};
}

1;

__END__

=head1 NAME

Class::DBI::Plugin::Connection - apply for Apache::DBI in mod_perl environment

=head1 SYNOPSIS

  package CD;
  use base qw(Class::DBI);

  use Class::DBI::Plugin::Connection;
  # then connection type is automatically selected.
  # use DBI::connect instead of DBI::connect_chached
  # in mod_perl environment.

  # or you can force to set.
  __PACKAGE__->connection_caching(1);

  # now CDBI connects to database with selected proper method.
  __PACKAGE__->set_db(...);

=head1 DESCRIPTION

This module handles CDBI app's connection type.

CDBI makes connection with DBI::connect_cached
to dicrease connection costs. This is better most of the time.

But when you want to use CDBI in mod_perl environment,
Maybe you want to use Apache::DBI for persistent connection.
Apache::DBI doesn't support connect_cached.

As the solution for this problem, you can use this module.

=head1 PROPERTY

=over 4

=item connection_caching

All you have to do is to write 'use Class::DBI::Plugin::Connection;',
and proper connection method will be selected automatically.
But if there are times when you want to choose connection type yourself,
set this property.

  __PACKAGE__->connection_caching(0); # connect with DBI->connect(...)

  __PACKAGE__->connection_caching(1); # connect with DBI->connect_cached(...)

=back

=head1 AUTHOR

Lyo Kato E<lt>kato@lost-season.jpE<gt>

=head1 SEE ALSO

L<Class::DBI>, L<Apache::DBI>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by Lyo Kato.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
