// Copyright 1995 Michael E. Stillman

#include "ring.hpp"
#include "monoid.hpp"
#include "monideal.hpp"
#include "respoly.hpp"
#include "polyring.hpp"

#include "freemod.hpp"

#if 0
void Ring::Ring()
  : immutable_object(0),
    P(0),
    nvars(0),
    totalvars(0),
    K(0),
    M(0),
    D(0),
    HRing(0),
    vecstash(0),
    resstash(0),
    isquotientring(0),
    is_ZZ_quotient(0),
    ZZ_quotient_value(0),
    isfield(0),
    zero_divisor(0),
  // Set all values to 0.  Caller MUST call an initialize routine afterwords.
{
}
#endif

Ring::Ring(int P, 
	     int n, 
	     int totaln,
	     const Ring *KK,
	     const Monoid *MM,
	     const Monoid *DD)
: immutable_object(0), P(P), nvars(n), totalvars(totaln), K(KK), M(MM), D(DD),
HRing(NULL)
{
  if (D->n_vars() > 0)
    {
      HRing = PolynomialRing::create(ZZ, D);
    }
  else
    HRing = NULL;

  int msize = M->monomial_size();
  vecstash = new stash("vectors",
		       sizeof(vecterm) +
		       (msize-1) * sizeof(int));
  // Set up the resterm stash
  resstash = new stash("respoly", sizeof(resterm *) + sizeof(res_pair *)
		     + sizeof(ring_elem)
		     + sizeof(int) * M->monomial_size());

  isfield = false;
  isquotientring = false;
  zero_divisor = (Nterm *)0;

  is_ZZ_quotient = false;
  ZZ_quotient_value = (Nterm *)0;
}

Ring::Ring(const Ring &R)
: immutable_object(0),
  P(R.P),
  nvars(R.nvars),
  totalvars(R.totalvars),
  K(R.K),
  M(R.M),
  D(R.D),
  HRing(R.HRing),
  zero_divisor((Nterm *)0),
  isfield(false),
  isquotientring(true),
  is_ZZ_quotient(false), // Needs to be set in polynomial ring creation
  ZZ_quotient_value((Nterm *)0), // Ditto.
  vecstash(R.vecstash),
  resstash(R.resstash)
{
}

Ring::~Ring()
{
  // PROBLEM: zero_divisor needs to be freed: this MUST be done by the specific ring.
  // PROBLEM: resstash, vecstash need to be freed, if this is not a quotient.
  if (!isquotientring)
    {
      delete vecstash;
      delete resstash;
    }
}

FreeModule *Ring::make_FreeModule() const
{ 
  return new FreeModule(this); 
}

FreeModule *Ring::make_FreeModule(int n) const
{ 
  return new FreeModule(this,n);
}

bool Ring::is_field() const 
{ 
  return isfield; 
}
void Ring::declare_field() 
{ 
  isfield = true; 
}
ring_elem Ring::get_zero_divisor() const 
{ 
  return copy(zero_divisor); 
}


void Ring::remove_vector(vec &v) const
{
  while (v != NULL)
    {
      vecterm *tmp = v;
      v = v->next;
      K->remove(tmp->coeff);
      vecstash->delete_elem(tmp);
    }
}

void Ring::mult_to(ring_elem &f, const ring_elem g) const
{
  ring_elem h = mult(f,g);
  remove(f);
  f = h;
}

int Ring::coerce_to_int(ring_elem) const
{
  ERROR("cannot coerce given ring element to an integer");
  return 0;
}

ring_elem Ring::from_double(double a) const
{
  mpz_t f;
  mpz_init(f);
  mpz_set_d(f,a);
  ring_elem result = from_int(f);
  mpz_clear(f);
  return result;
}

ring_elem Ring::random() const
{
  ERROR("random scalar elements for this ring are not implemented");
  return 0;
}
ring_elem Ring::random(int /*homog*/, const int * /*deg*/) const
{
  ERROR("random non-scalar elements for this ring are not implemented");
  return 0;
}

ring_elem Ring::preferred_associate(ring_elem f) const
{
  // Here we assume that 'this' is a field:
  if (is_zero(f)) return from_int(1);
  return invert(f);
}

int Ring::n_terms(const ring_elem) const
{
  return 1;
}
ring_elem Ring::term(const ring_elem a, const int *) const
{
  return copy(a);
}
ring_elem Ring::lead_coeff(const ring_elem f) const
{
  return f;
}
ring_elem Ring::get_coeff(const ring_elem f, const int *) const
{
  return f;
}
ring_elem Ring::get_terms(const ring_elem f, int, int) const
{
  return f;
}

ring_elem Ring::homogenize(const ring_elem f, int, int deg, const M2_arrayint) const
{
  if (deg != 0) 
    ERROR("homogenize: no homogenization exists");
  return f;
}

ring_elem Ring::homogenize(const ring_elem f, int, const M2_arrayint) const
{
  return f;
}

bool Ring::is_homogeneous(const ring_elem) const
{
  return true;
}

void Ring::degree(const ring_elem, int *d) const
{
  degree_monoid()->one(d);
}
void Ring::degree_weights(const ring_elem, const M2_arrayint, int &lo, int &hi) const
{
  lo = hi = 0;
}
int Ring::primary_degree(const ring_elem) const
{
  return 0;
}
