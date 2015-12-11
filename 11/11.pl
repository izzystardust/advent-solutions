sub shitty_regex {
    $str = shift
    return $str =~ /.*(abc|bcd|cde|def|efg|fgh|ghi|hik|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz).*/;
}

sub valid {
    $str=shift;
    return ($str =~ /(.)\1.*(.)\2/ and $str =~ /^((?![oil]).)*$/ and shitty_regex($str));
}

$pw = ++$ARGV[0];

until ( valid( $pw ) ) {
        $pw = ++$pw;
}

print "$pw\n"
