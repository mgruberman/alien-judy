package My::Judy::Builder;

use strict;
use warnings;

use Module::Build;
our @ISA = 'Module::Build';

use Config '%Config';
use File::Spec;
use Cwd 'cwd';

our $Orig_CWD = cwd();

sub _chdir_to_judy { chdir 'src/Judy-1.0.4' or die "Can't chdir to src/Judy-1.0.4: $!" }
sub _chdir_back { chdir $Orig_CWD or die "Can't chdir to $Orig_CWD: $!" }
use constant MAKE => [];

sub _run {
    my($self, $prog, @args) = @_;
    
    $prog = $self->notes('your_make') if $prog eq MAKE();
    
    return system( "$prog @args" ) == 0 ? 1 : 0;
}


sub _run_judy_configure {
    my ($self) = @_;
    
    if ( $self->notes('build_judy') =~ /^y/i ) {
	_chdir_to_judy();
	
	$self->_run( qw( sh configure ), $self->notes('configure_args') )
	    or do { warn "configuring Judy failed";      return 0 };
	
	_chdir_back();
    }
}

sub _default_config_args {
    my ($self) = @_;

    my $props = $self->{properties};
    my $prefix = $props->{install_base} ||
	$props->{prefix} ||
	$Config{siteprefix};

    my %args = (
        prefix => $prefix,
        libdir => File::Spec->catdir(
            $self->install_destination('arch'), 'Alien', 'Judy'
        ),
	);
    
    return join ' ', map { "--$_=$args{$_}" } sort keys %args;
    
}

sub ACTION_code {
    my ($self) = @_;

   if ( $self->notes('build_judy') =~ /^y/i ) {
	$self->SUPER::ACTION_code;

	_chdir_to_judy();
	
	$self->_run(MAKE())
	    or do {
		warn "building Judy failed";
		_chdir_back();
		return 0 };
	
	_chdir_back();

	return 1;
    }
    else {
    	return $self->SUPER::ACTION_code;
    }
}


sub ACTION_test {
    my ($self) = @_;
    
    if ( $self->notes('build_judy') =~ /^y/i ) {
        $self->SUPER::ACTION_test;
    
	_chdir_to_judy();
	
	$self->_run( MAKE(), 'check' )
	    or do {
		warn "checking Judy failed ";
		_chdir_back();
		return 0 };
	
	_chdir_back();

	return 1;
    }
    else {
    	return $self->SUPER::ACTION_test;
    }
}

sub ACTION_install {
    my ($self) = @_;
    
    if ( $self->notes('build_judy') =~ /^y/i ) {
	$self->SUPER::ACTION_install;

	_chdir_to_judy();
	
	$self->_run( MAKE(), 'install' )
	    or do {
		warn "installing Judy failed ";
		_chdir_back();
		return 0 };
	
	_chdir_back();

	return 1;
    }
    else {
    	return $self->SUPER::ACTION_install;
    }
}


1;
