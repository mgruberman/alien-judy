package My::Judy::Builder;

use strict;
use warnings;

use Module::Build;
BEGIN { our @ISA = 'Module::Build' }

use Config '%Config';
use File::Spec;
use Cwd 'cwd';

my $Orig_CWD;
BEGIN { $Orig_CWD = cwd() }

sub _chdir_to_judy { chdir 'src/Judy-1.0.4' or die "Can't chdir to src/Judy-1.0.4: $!" }
sub _chdir_back { chdir $Orig_CWD or die "Can't chdir to $Orig_CWD: $!" }
sub MAKE () { 'MAKE' }

sub _run {
    my($self, $prog, @args) = @_;
    
    $prog = $self->notes('your_make') if $prog eq MAKE();
    
    print "Running $prog @args\n";
    return system($prog, @args) == 0 ? 1 : 0;
}


sub _run_judy_configure {
    my ($self) = @_;
    
    if ( $self->notes('build_judy') =~ /^y/i ) {
	_chdir_to_judy();
	
	$self->_run(join ' ', qw( sh configure ), $self->notes('configure_args') )
	    or do { warn "configuring SVN failed";      return 0 };
	
	_chdir_back();
    }
}

sub ACTION_code {
    my ($self) = @_;

    $self->SUPER::ACTION_code;

    if ( $self->notes('build_judy') =~ /^y/i ) {
	_chdir_to_judy();
	
	$self->_run(MAKE())
	    or do { warn "building Judy failed"; return 0 };
	
	_chdir_back();
    }
    
    return 1;
}


sub ACTION_test {
    my ($self) = @_;
    
    $self->SUPER::ACTION_code;

    if ( $self->notes('build_judy') =~ /^y/i ) {
	_chdir_to_judy();
	
	$self->_run( MAKE(), 'check' )
	    or do { warn "checking Judy failed "; return 0 };
	
	_chdir_back();
    }

    return 1;
}

sub ACTION_install {
    my ($self) = @_;
    
    $self->SUPER::ACTION_code;

    if ( $self->notes('build_judy') =~ /^y/i ) {
	_chdir_to_judy();
	
	$self->_run( MAKE(), 'install' )
	    or do { warn "installing Judy failed "; return 0 };
	
	_chdir_back();
    }

    return 1;
}


1;
