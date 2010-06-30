#!perl -w
use strict;
use 5.005;

# use inc/latest.pm to load either the bundled inc/Module/Build.pm or
# your perl's own Module::Build.
#use inc::latest 'Module::Build';
require inc::latest;
push @INC, 'inc';
inc::latest->import( 'Module::Build' );

# use inc/latest.pm to load either the bundled inc/File/Which.pm or
# your perl's own File::Which.
#use inc::latest 'File::Which';
inc::latest->import( 'File::Which' );

# Add 'inc/' to @INC so the builder will take note of how to find
# inc/My/Judy/Builder.pm.
#
# Load inc/My/Judy/Builder.pm
require My::Judy::Builder;

# Load *this* Alien::Judy from lib/Alien/Judy.pm and not any copy
# installed into this perl already.
require 'lib/Alien/Judy.pm';
$INC{'Alien/Judy.pm'} = 'lib/Alien/Judy.pm';

# Loading lib/Alien/Judy.pm may load a stub copy of
# inc/Sub/Exporter.pm. This happens if you do not already have
# Sub::Exporter installed. The module uses Sub::Exporter for the
# user's convenience but it is not needed during this Build.PL or
# Build program.
#
# Remove the evidence of my stub Sub::Exporter so Module::Build can
# still try to resolve the requirement if needed.
if ( $main::INC_SUB_EXPORTER || $main::INC_SUB_EXPORTER ) {
    delete $INC{'Sub/Exporter.pm'};
}

require ExtUtils::Liblist;
require Config;

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
