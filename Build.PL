use strict;
use warnings;
use lib 'inc';

use My::Judy::Builder;
use ExtUtils::Liblist;
use Config '%Config';

my $builder = My::Judy::Builder->new(
    module_name         => 'Alien::Judy',
    license             => 'perl',
    dist_author         => 'Joshua ben Jore <jjore@cpan.org>',
    dist_version_from   => 'lib/Alien/Judy.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Alien-Judy-*' ],
    create_makefile_pl => 'passthrough',
);

$builder->create_build_script();

my $have_judy =
    grep { $_ }
    ExtUtils::Liblist->ext('-lJudy',1);
$builder->notes('have_judy', $have_judy );

my $build_judy = 'y';
if ( $have_judy ) {
    $build_judy = $builder->prompt('Found -lJudy. Build Judy anyway?', 'n');
}
$builder->notes('build_judy',$build_judy);


if ( $build_judy =~ /^y/i ) {
    print <<'END';

---------------------------------------------------------------------
This module will build and install Judy.

It requires a C compiler and make.
END

    my $make = $builder->prompt('Make program: ', $Config{make} );
    $builder->notes('your_make', $make);


    my $run_configure = 'y';
    if ( -e 'src/Judy-1.0.4/Makefile' && -e 'src/Judy-1.0.4/config.h' ) {
	$run_configure = $builder->prompt("Re-run Judy's configure? ", 'n');
    }
    else {
	$run_configure = $builder->prompt("Run Judy's configure now? ",'y');
    }
    
    if ( $run_configure =~ /^y/i ) {
	my $configure_args = $builder->prompt( "Pass any arguments to configure (eg, --prefix=/usr/local): ", '' );
	$builder->notes("configure_args", $configure_args);
	
	if( $builder->_run_judy_configure ) {
	    print "\n\nYou should now run ./Build.\n";
	}
	else {
	    print <<'END';
    Something went wrong with the Judy configuration.
    You should correct it and re-run Build.PL.
END
            exit 1;
	}
    }
}
