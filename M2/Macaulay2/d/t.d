use C;
use system;
use stdio;
use strings;
use gmp;

x := - ( 2 * 333^33 + 251174 - 1 );
y := 3^44;
z := 5^21;
stdout << x << endl;
stdout << toDouble(x) << endl;
stdout << gcd(x*y, x*z) << endl;

flush(stdout);

-- Local Variables:
-- compile-command: "cd ../../tmp/Macaulay2/d; make t"
-- End:
