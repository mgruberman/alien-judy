#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Alien::Judy' );
}

diag( "Testing Alien::Judy $Alien::Judy::VERSION, Perl $], $^X" );
