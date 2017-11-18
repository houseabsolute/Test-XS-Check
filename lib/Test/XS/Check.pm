package Test::XS::Check;

use strict;
use warnings;

our $VERSION = '0.02';

use Test2::API qw( context );
use XS::Check 0.07;

our @EXPORT_OK = qw( xs_ok );

use Exporter qw( import );

sub xs_ok {
    my $file = shift;

    my $context = context();

    my @errors;
    my $check = XS::Check->new( reporter => sub { push @errors, {@_} } );
    $check->check_file($file);

    $context->ok( !@errors, "XS check for $file" );
    if (@errors) {
        $context->diag("$_->{message} at line $_->{line}") for @errors;
    }
    $context->release;

    return !@errors;
}

1;

# ABSTRACT: Test that your XS files are problem-free with XS::Check

__END__

=head2 SYNOPSIS

    use Test2::V0;
    use Test::XS::Check qw( xs_ok );

    xs_ok('path/to/File.xs');

    done_testing();

=head2 DESCRIPTION

This module wraps Ben Bullock's L<XS::Check> module in a test module that you
can incorporate into your distribution's test suite.

=head2 EXPORTS

This module exports one subroutine on request.

=head3 xs_ok($path)

Given a path to an XS file, this subroutine will run that file through
L<XS::Check>. If any XS issues are found, the test fails and the problems are
emitted as diagnostics. If no issues are found, the test passes.
