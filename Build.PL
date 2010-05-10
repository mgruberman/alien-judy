#!perl
use strict;
use 5.005;
use warnings;
use lib qw( inc lib );

use My::Judy::Builder;
use Alien::Judy ();
use ExtUtils::Liblist;
use Config ();

my $builder = My::Judy::Builder->new(
    module_name         => 'Alien::Judy',
    license             => 'perl',
    dist_author         => 'Joshua ben Jore <jjore@cpan.org>',
    dist_version_from   => 'lib/Alien/Judy.pm',
    build_requires => {
        'ExtUtils::CBuilder' => 0,
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Alien-Judy-*' ],
);

$builder->create_build_script();

my $have_judy = 1;
{
    local $SIG{__WARN__} = sub {
        my $warning = "@_";
        if ( $warning =~ /No library found for -lJudy/ ) {
            $have_judy = 0;
        }
    };

    my $lib_dirs =
        join ' ',
        map { "-L$_" }
        Alien::Judy::lib_dirs();

    ExtUtils::Liblist->ext(
        "$lib_dirs -lJudy",
        1
    );
}
$builder->notes('have_judy', $have_judy );

my $build_judy = 'y';
if ( $have_judy ) {
    $build_judy = $builder->prompt('Found -lJudy. Build Judy anyway?', 'n');
}
$builder->notes('build_judy',$build_judy);


if ( $build_judy =~ /^y/i ) {
    print q{

---------------------------------------------------------------------
This module will build and install Judy.

It requires a C compiler and make.
};

    my $make = $builder->prompt('Make program: ', $Config::Config{make} );
    $builder->notes('your_make', $make);


    my $run_configure = 'y';
    if (    -e 'src/judy-1.0.4/Makefile'
         && -e 'src/judy-1.0.4/config.h'
    ) {
	$run_configure = $builder->prompt("Re-run Judy's configure? ", 'n');
    }
    else {
	$run_configure = $builder->prompt("Run Judy's configure now? ",'y');
    }
    
    if ( $run_configure =~ /^y/i ) {
	my $configure_args = $builder->prompt(
            'Pass any arguments to configure: ',
            $builder->_default_config_args
        );
	$builder->notes("configure_args", $configure_args);
	
	if( $builder->_run_judy_configure ) {
	    print q{

You should now run ./Build.
};
	}
	else {
	    print q{
    Something went wrong with the Judy configuration.
    You should correct it and re-run Build.PL.
};
            exit 1;
	}
    }
}
