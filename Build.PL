#!perl -w
use strict;
use 5.005;
use lib 'inc';

# Load inc/My/Judy/Builder.pm
use My::Judy::Builder;

# Load either your installed copy of File::Which or a private version
# of it which I've copied into inc/File/Which.pm. The inc/ directory
# ought to be last in @INC so inc/ won't override anything that's
# locally installed.
use File::Which ();

# Load *this* Alien::Judy from lib/Alien/Judy.pm and not any copy
# installed into this perl already.
BEGIN {
    require 'lib/Alien/Judy.pm';
    $INC{'Alien/Judy.pm'} = 'lib/Alien/Judy.pm';

    # Loading lib/Alien/Judy.pm may load a stub copy of
    # inc/Sub/Exporter.pm. This happens if you do not already have
    # Sub::Exporter installed. The module uses Sub::Exporter for the
    # user's convenience but it is not needed during this Build.PL or
    # Build program.
    #
    # Remove the evidence of my stub Sub::Exporter so Module::Build
    # can still try to resolve the requirement if needed.
    if ( $main::INC_SUB_EXPORTER ) {
        delete $INC{'Sub/Exporter.pm'};
    }
}

use ExtUtils::Liblist;
use Config ();

my %configure_requires = (
    'perl' => '5.005',

    # Core only and unavailable on CPAN

    # Perl 5+
    'Cwd'               => 0,

    # Perl 5.1+
    'ExtUtils::Liblist' => 0,
    'File::Path'        => 0,
    'lib'               => 0,

    # Perl 5.2+
    'File::Copy'        => 0,
    'vars'              => 0,

    # Perl 5.3.7+
    # 'Config' => 0,

    # Perl 5.5+
    'File::Spec'        => 0,

    # Perl 5.6+
    'warnings'          => 0,

    # Perl 5.9.4+
    'Module::Build'     => 0,
);
my %build_requires = (
    %configure_requires,

    # Perl 5.6.2+
    'Test::More'         => 0,

    # Perl 5.9.3+
    'ExtUtils::CBuilder' => 0,
);
my %requires = (
    %build_requires,

    # CPAN
    'Sub::Exporter'     => 0,
);

my $builder = My::Judy::Builder->new(
    module_name         => 'Alien::Judy',
    license             => 'perl',
    configure_requires  => \ %configure_requires,
    build_requires      => \ %build_requires,
    requires            => \ %requires,
    add_to_cleanup      => [
        'Alien-Judy-*',
        # TODO: all the generated files by src/judy-1.0.5/
    ],

    create_readme  => 1,
    dynamic_config => 1,
);

$builder->create_build_script();
$builder->_setup_for_judy;
