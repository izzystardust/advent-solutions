#!/usr/bin/perl
##
# Advent of code, day 11.
# Solution of millere@github. `strict` version by kannix68@github.
# Variant of <https://github.com/millere/advent-solutions/blob/master/11/11.pl>
#

require 5;
use strict;
use warnings;

sub shitty_regex($) {
    my $str = shift;
    return $str =~ /(abc|bcd|cde|def|efg|fgh|ghi|hik|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)/;
}

sub valid($) {
    my $str = shift;
    return ($str =~ /(.)\1.*(.)\2/ and $str =~ /^[^oil]+$/ and shitty_regex($str) and $str =~ /^[a-z]{8}$/);
}

my $pw = ++$ARGV[0];

until ( valid($pw) ) {
    $pw = ++$pw;
}

print "$pw\n"
