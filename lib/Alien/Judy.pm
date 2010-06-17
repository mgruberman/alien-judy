# This is the Alien::Judy module, a way to ensure that users who don't
# natively have libJudy on their system can still get one. It provides
# libJudy.so and Judy.h at the path $Config{sitearch}/Alien/Judy.
package Alien::Judy;

use strict;
use warnings;
use vars qw( $VERSION );
use Config ();
use Cwd ();
use File::Spec ();

# This module allows users to import its two public functions
# inc_dirs() and lib_dirs().
use Sub::Exporter -setup => {
    exports => [qw( inc_dirs lib_dirs )]
};


sub unique {
    my %seen;
    return
        grep { ! $seen{$_}++ }
        @_;
}

sub inc_dirs {
    return
        unique(
            Cwd::getcwd(),
            map { File::Spec->catdir( $_, 'Alien', 'Judy' ) }
            grep { defined() && length() }
            @Config::Config{qw(sitearchexp sitearch)},
            @INC
        );
}

*lib_dirs = \&inc_dirs;

$VERSION = '0.17';

1;
