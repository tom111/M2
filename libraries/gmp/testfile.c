/*

   Bug in mpir 1.2.1.

   This program demonstrates that mpn_lshift, as implemented on 64 bit intel machines by mpn/lshift.as, gives
   the wrong answer if the limbs are not aligned to an 8 byte boundary.

   Even if the default allocator always returns 8-byte aligned memory blocks, this is a bug, because the
   documentation on "Custom Allocation" doesn't require custom memory allocators to obey any alignment requirements.
  
   Here's the output from the program

	5285209847924392297689518137364380393182068736
	5285209916707841180605126409194605050347913216

   Correct output would have the second line the same as the first.

   Linux fedora64 2.6.31.6-162.fc12.x86_64 #1 SMP Fri Dec 4 00:06:26 EST 2009 x86_64 x86_64 x86_64 GNU/Linux

   gcc version 4.4.2 20091027 (Red Hat 4.4.2-7) (GCC) 

 */

#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>
#include <assert.h>

int main (int argc, char **argv) {
  mpz_t rp, sp;
  mpz_init2 (rp, 10 * 64);
  mpz_init2 (sp, 10 * 64);
  mpz_set_str (rp, "660651230990549037211189767170547549147758592", 10);

  mpz_set_str (sp, "660651230990549037211189767170547549147758592", 10);
  mpn_lshift (rp -> _mp_d, sp -> _mp_d, 3, 3);
  mpz_out_str(stdout, 10, rp);
  printf("\n");

  sp->_mp_d = (mp_limb_t *)((char *)sp->_mp_d + 4);

  mpz_set_str (sp, "660651230990549037211189767170547549147758592", 10);
  mpn_lshift (rp -> _mp_d, sp -> _mp_d, 3, 3);
  mpz_out_str(stdout, 10, rp);
  printf("\n");

  return 0;
}

/*
 Local Variables:
 compile-command: "make -C $M2BUILDDIR/libraries/gmp testfile LOADLIBES=-lgmp LDFLAGS='-Wl,-Map,mapfile -L../final/lib' CPPFLAG=-I../final/include && (set -x ; grep LOAD $M2BUILDDIR/libraries/gmp/mapfile ; $M2BUILDDIR/libraries/gmp/testfile )"
 End:
*/
