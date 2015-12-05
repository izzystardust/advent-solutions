#!/usr/bin/env tclsh

proc threeVowels {word} {
	return [string match {*[aeiou]*[aeiou]*[aeiou]*} $word]
}

proc doubleLetter {word} { return [regexp {.*(\w)\1.*} $word] }

# ab, cd, pq, xy
proc noBadSubs {word} {
	return [expr {! [regexp {.*(ab|cd|pq|xy).*} $word]}]
}

proc niceword {word} {
	return [expr {[threeVowels $word] && [doubleLetter $word] && [noBadSubs $word]}]
}

proc pairTwice {word} { return [regexp {.*(..).*\1.*} $word] }
proc splitPair {word} { return [regexp {.*(.).\1.*} $word] }

proc niceword2 {word} {
	return [expr {[pairTwice $word] && [splitPair $word]}]
}

set nicecount 0
set nicecount2 0

while {![eof stdin]} {
	set word [gets stdin]
	if { [niceword $word] } { incr nicecount }
	if { [niceword2 $word] } { incr nicecount2 }
}

puts "Nice words: $nicecount"
puts "Nicer words: $nicecount2"
