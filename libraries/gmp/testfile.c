#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>
#include <assert.h>

int main (int argc, char **argv) {
  mpz_t dividend, divisor, quotient, remainder, quotient2, remainder2, temp;
  mpz_init (dividend);
  mpz_init (divisor);
  mpz_init (quotient);
  mpz_init (remainder);
  mpz_init (quotient2);
  mpz_init (remainder2);
  mpz_init (temp);
  assert(0 == mpz_set_str (dividend, "101506308928235398946510927768391420311764992000", 10));
  assert(0 == mpz_set_str (divisor, "27656345068767491604576153420888539136", 10));
  mpz_fdiv_qr (quotient, remainder, dividend, divisor);
  printf("dividend  = ");
  mpz_out_str(stdout, 10, dividend);
  printf("\n");
  printf("divisor   = ");
  mpz_out_str(stdout, 10, divisor);
  printf("\n");
  printf("quotient  = ");
  mpz_out_str(stdout, 10, quotient);
  printf("\n");
  printf("remainder = ");
  mpz_out_str(stdout, 10, remainder);
  printf("\n");
  mpz_fdiv_q (quotient2, dividend, divisor);
  mpz_fdiv_r (remainder2, dividend, divisor);
  assert(mpz_cmp (quotient, quotient2) == 0);
  assert(mpz_cmp (remainder, remainder2) == 0);
  assert(!((mpz_cmp_ui (quotient, 0) != 0) &&
	   ((mpz_cmp_ui (quotient, 0) < 0)
	    != ((mpz_cmp_ui (dividend, 0) ^ mpz_cmp_ui (divisor, 0)) < 0))));
  assert(!((mpz_cmp_ui (remainder, 0) != 0) &&
	   ((mpz_cmp_ui (remainder, 0) < 0) != (mpz_cmp_ui (divisor, 0) < 0))));
  mpz_mul (temp, quotient, divisor);
  mpz_add (temp, temp, remainder);
  assert(mpz_cmp (temp, dividend) == 0);
  mpz_abs (temp, divisor);
  mpz_abs (remainder, remainder);
  assert(mpz_cmp (remainder, temp) < 0);
  mpz_clear (dividend);
  mpz_clear (divisor);
  mpz_clear (quotient);
  mpz_clear (remainder);
  mpz_clear (quotient2);
  mpz_clear (remainder2);
  mpz_clear (temp);
  printf("test passed\n");
  return 0;
}

/*
 Local Variables:
 compile-command: "make -C $M2BUILDDIR/libraries/gmp testfile LOADLIBES=-lgmp LDFLAGS=-L../final/lib CPPFLAG=-I../final/include && (set -x ; $M2BUILDDIR/libraries/gmp/testfile )"
 End:
*/
