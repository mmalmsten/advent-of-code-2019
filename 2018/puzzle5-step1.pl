use strict; 
use warnings; 

open(fh, "puzzle5.txt"); 
my $string = <fh>; 

my $n = 0;
my $length = length($string);
 
while ($n + 1 < $length) {
	if (
		substr($string, $n,1) ne substr($string, $n + 1,1) && 
		lc(substr($string, $n,1)) eq lc(substr($string, $n + 1,1))
	) {
		substr($string, $n, 2) = "";
		$length -= 2;
		$n -= 1;
	} else {
		$n += 1;
	}
}

print(length($string));