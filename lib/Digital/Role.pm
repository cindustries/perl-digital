package Digital::Role;
# ABSTRACT: Base role for Digital driver (positive integer input)

use Moo::Role;
use Carp qw( croak );

sub input {
  my ( $class, $input, %args ) = @_;
  return $class->new( in => $input, %args );
}

has in => (
  is => 'ro',
  isa => sub {
    croak "Digital input must be positive integer!"
      unless $_[0] =~ /^\d+$/ and $_[0] >= 0;
  },
  required => 1,
);

1;

=head1 SUPPORT

IRC

  Join #hardware on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  https://github.com/homehivelab/p5-digital
  Pull request and additional contributors are welcome

Issue Tracker

  https://github.com/homehivelab/p5-digital/issues
