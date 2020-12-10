package Digital::Driver;
# ABSTRACT: Module for new drivers

use strict;
use warnings;
use Package::Stash;
use Carp qw( croak );
use MooX ();
use Import::Into;
use Digital ();

sub import {
  my ( $class, @args ) = @_;
  my $driver_role;
  for (@args) {
    if ($_ =~ m/^-(.+)/) {
      croak $class.' already has a driver role' if $driver_role;
      $driver_role = 'Digital::Role::'.$1;
    }
  }
  $driver_role = 'Digital::Role' unless $driver_role;
  my ( $caller ) = caller;
  MooX->import::into($caller);
  $caller->can('with')->($driver_role);
  $class->install_helper($caller);
  Digital->register_input($caller);
}

sub install_helper {
  my ( $class, $target ) = @_;
  my $stash = Package::Stash->new($target);
  $stash->add_symbol('&to', sub {
    my ( $to, $coderef, $via ) = @_;
    $target->can('has')->( $to,
      is => 'lazy',
      init_arg => undef,
    );
    $stash->add_symbol('&_build_'.$to, sub {
      my ( $self ) = @_;
      my $value = defined $via ? $self->$via : $self->in;
      return $coderef->($self,$value) for ($value);
    });
  });
  $stash->add_symbol('&overload_to', sub {
    my ( $to, @args ) = @_;
    overload->import::into($target,
      '0+', sub { shift->$to },
      fallback => 1,
    );
    return $target->can('to')->($to, @args);
  });
}

1;

=head1 SUPPORT

IRC

  Join #hardware on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  https://github.com/cindustries/perl-digital
  Pull request and additional contributors are welcome

Issue Tracker

  https://github.com/cindustries/perl-digital/issues
