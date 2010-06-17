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

# The provided functions inc_dirs() and lib_dirs() are currently
# identical. Initially, they weren't.
*lib_dirs = \&inc_dirs;

sub inc_dirs {
    my %seen;
    return
        grep { ! $seen{$_}++ }
            Cwd::getcwd(),
            map { File::Spec->catdir( $_, 'Alien', 'Judy' ) }
            grep { defined() && length() }
            @Config::Config{qw(sitearchexp sitearch)},
            @INC;
}

$VERSION = '0.17';

1;
