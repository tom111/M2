#ifndef __montableZZ_h
#define __montableZZ_h

#include "buffer.hpp"
#include "newdelete.hpp"
#include "style.hpp"

#include <vector>
#include <memory>
#include <algorithm>
#include <stdio.h>
#include <stddef.h>
#include <gmp.h>
#include <mpfr.h>

/* "Tricks" used in this implementation */
/*
 1. exponent vectors: these look like: [e1, ..., en],
    where n is the number of variables.  HOWEVER, these
    exponents are never created or freed by these routines,
    so if they have more entries (e.g. a "sugar" homogenization)
    then that (those) value(s) are ignored.
 2. comparison routine: elements are kept in (increasing?) lex order.
    Is this really an OK idea?
 */

typedef int *exponents;

class MonomialTableZZ : public our_new_delete
{
 public:
  struct mon_term : public our_new_delete
  {
    mon_term *_next;
    mon_term *_prev;
    exponents _lead; /* Who owns this? */
    unsigned long _mask;
    int _val;
    mpz_srcptr _coeff; /* If not given, this is NULL. Ig given, it points to data elsewhere (e.g. a GB) which will outlive this data  */
  };

  static MonomialTableZZ *make(int nvars);
  /* Create a zero element table */

  ~MonomialTableZZ();

  void insert(mpz_srcptr coeff, exponents exp, int comp, int id);
  /* Insert [coeff,exp,comp,id] into the table.  If there is already
     an element which is <= [exp,comp], this triple is still
     inserted.  If that is not desired, use find_divisors.
  */

  bool is_weak_member(mpz_srcptr c, exponents exp, int comp) const;
  // Is [c,exp,comp] in the submodule generated by the terms in 'this'?
  // Maybe a gbvector should be returned?

  bool is_strong_member(mpz_srcptr c, exponents exp, int comp) const;
  // Is [c,exp,comp] divisible by one of the terms in 'this'?

  int find_smallest_coeff_divisor(exponents exp, int comp) const;
  // Of all of the elements which divide exp*comp, return the index of the
  // smallest coefficient one, or return -1, if no element divides exp*comp.

  int find_term_divisors(int max,
                         mpz_srcptr coeff,
                         exponents exp,
                         int comp,
                         VECTOR(mon_term *) *result = 0) const;
  /* max: the max number of divisors to find.
     exp: the monomial whose divisors we seek.
     result: an array of mon_term's.
     return value: length of this array, i.e. the number of matches found */

  int find_monomial_divisors(int max,
                             exponents exp,
                             int comp,
                             VECTOR(mon_term *) *result = 0) const;

  mon_term *find_exact(mpz_srcptr coeff, exponents exp, int comp) const;
  /* If this returns non-NULL, it is valid to grab the 'val' field, and/or to
     assign to it.
     All other fields should be considered read only */

  mon_term *find_exact_monomial(exponents exp, int comp, int first_val) const;
  // Is there an element 'exp*comp' with _val >= first_val?  If so, return the
  // mon_term.
  // Otherwise return 0.

  void change_coefficient(mon_term *t, mpz_srcptr new_coeff, int new_id);

  static void find_weak_generators(int nvars,
                                   const VECTOR(mpz_srcptr) & coeffs,
                                   const VECTOR(exponents) & exps,
                                   const VECTOR(int) & comps,
                                   VECTOR(int) & result_positions,
                                   bool use_stable_sort = true);

  static void find_strong_generators(int nvars,
                                     const VECTOR(mpz_srcptr) & coeffs,
                                     const VECTOR(exponents) & exps,
                                     const VECTOR(int) & comps,
                                     VECTOR(int) & result_positions);

  void show_mon_term(FILE *fil, mon_term *t) const; /* Only for debugging */
  void show_mon_term(buffer &o, mon_term *t) const; /* Only for debugging */
  void show_mon_term(buffer &o,
                     mpz_srcptr coeff,
                     exponents lead,
                     int comp) const; /* Only for debugging */
  void show(FILE *fil) const;         /* Only for debugging */
  void showmontable();
  void show_weak(FILE *fil,
                 mpz_srcptr coeff,
                 exponents exp,
                 int comp,
                 int val) const; /* Debugging */

 private:
  int _nvars;
  int _count;
  VECTOR(mon_term *) _head; /* One per component */

  static mon_term *make_list_head();
};

#endif

// Local Variables:
// compile-command: "make -C $M2BUILDDIR/Macaulay2/e "
// indent-tabs-mode: nil
// End:
