package Alien::Judy;

use strict;
use warnings;

use vars qw( @EXPORT_OK %EXPORT_TAGS $VERSION );

use Config ();
use File::Spec ();

use Exporter ();
*import = \&Exporter::import;

@EXPORT_OK = qw( inc_dirs lib_dirs );
%EXPORT_TAGS = (
    all => \ @EXPORT_OK,
);

sub unique {
    my %seen;
    return
        grep { ! $seen{$_}++ }
        @_;
}

sub inc_dirs {
    return
        grep { $_ && -d }
        unique(
            Cwd::getcwd(),
            map { File::Spec->catdir( $_, 'include' ) }
            @Config::Config{qw( siteprefixexp prefixexp )}
        );
}

sub lib_dirs {
    return
        grep { $_ && -d }
        unique(
            map { File::Spec->catdir( $_, 'Alien', 'Judy' ) }
            @Config::Config{qw(sitearchexp sitearch)}
        );
}

$VERSION = '0.09';

1;
