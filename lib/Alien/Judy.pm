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

# TODO: add literate documentation
sub inc_dirs {
    # Find files from ., $sitearch and @INC.
    my @dirs =
        grep { defined() && length() }
            @Config::Config{qw(sitearchexp sitearch)},
            @INC,
            Cwd::getcwd();

    # But first try to find them in $_/Alien/Judy/
    unshift @dirs,
        map { File::Spec->catdir( $_, 'Alien', 'Judy' ) }
        @dirs;

    # Return the unique-ified list
    my %seen;
    return
        grep { ! $seen{$_}++ }
        @dirs;
}

$VERSION = '0.17';

1;
