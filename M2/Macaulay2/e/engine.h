/* Copyright 2002 by Michael E. Stillman */

#ifndef _engine_h_
#define _engine_h_

#include "../d/M2types.h"

#if defined(__cplusplus)
class Monomial;
class Monoid;
class Ring;
class FreeModule;
class MonomialIdeal;
class Matrix;
class RingElement;
class Vector;
class RingMap;
class SparseMutableMatrix;

typedef struct MonomialOrdering MonomialOrdering;
#else
/* Define the externally visible types here */
typedef struct Monomial Monomial;
typedef struct Monoid Monoid;
typedef struct Ring Ring;
typedef struct RingElement RingElement;
typedef struct FreeModule FreeModule;
typedef struct Vector Vector;
typedef struct Matrix Matrix;
typedef struct RingMap RingMap;
typedef struct SparseMutableMatrix SparseMutableMatrix;

typedef struct MonomialOrdering MonomialOrdering;
typedef struct MonomialIdeal MonomialIdeal;
typedef struct Monomial_pair Monomial_pair;
typedef struct RingElement_pair RingElement_pair;
typedef struct Matrix_pair Matrix_pair;
typedef struct Matrix_int_pair Matrix_int_pair;
typedef struct M2_Integer_pair M2_Integer_pair;
#endif

struct Monomial_pair { Monomial *a; Monomial *b; };
struct RingElement_pair { RingElement *a; RingElement *b; };
struct M2_Integer_pair { M2_Integer a; M2_Integer b; };
struct Matrix_pair { const Matrix *a; const Matrix *b; };
struct Matrix_int_pair { const Matrix *a; int b; };

typedef M2_bool VoidOrError;
typedef M2_Integer M2_IntegerOrNull;
typedef Monomial MonomialOrNull;
typedef Monoid MonoidOrNull;
typedef Ring RingOrNull;
typedef RingElement RingElementOrNull;
typedef FreeModule FreeModuleOrNull;
typedef Matrix MatrixOrNull;
typedef MonomialIdeal MonomialIdealOrNull;
typedef Vector VectorOrNull;
typedef RingMap RingMapOrNull;

typedef Matrix_pair Matrix_pair_OrNull;
typedef Matrix_int_pair Matrix_int_pair_OrNull;
typedef M2_Integer_pair M2_Integer_pair_OrNull;
typedef M2_arrayint M2_arrayint_OrNull;

typedef SparseMutableMatrix MutableMatrix;
typedef MutableMatrix MutableMatrixOrNull;

typedef struct M2_Integer_array {
  unsigned int len;
  M2_Integer array[1];
} M2_Integer_array;

typedef struct M2_MonomialOrdering_struct {
     unsigned int len;
     MonomialOrdering  *array[1];
     } *MonomialOrdering_array;

typedef struct Monomial_array {
  unsigned int len;
  const Monomial *array[1];
} Monomial_array;

typedef struct RingElement_array {
  unsigned int len;
  const RingElement *array[1];
} RingElement_array;

typedef struct ArrayPair {
  Monomial_array *monoms;
  RingElement_array *coeffs;
} *ArrayPairOrNull;  

typedef struct Vector_array {
  unsigned int len;
  const Vector *array[1];
} Vector_array;

typedef struct Matrix_array {
  unsigned int len;
  const Matrix *array[1];
} Matrix_array;
  
#if defined(__cplusplus)
extern "C" {
#endif
  void IM2_initialize(void);
  M2_string IM2_last_error_message(void);

  /* Other routine groups still to add:
     computations
       LLL
       Hermite
       Smith?
       GB (several versions)
       res (several versions)
       gb kernel 
       determinants
       pfaffians
       Hilbert functions?

     rings
       QQ, ...
  */
  /**************************************************/
  /**** Random numbers ******************************/
  /**************************************************/

  void IM2_random_seed(unsigned long seed); /* TODO */

  unsigned long IM2_random(); /* TODO */

  /* Other random number routines of interest:
     ringelement
     matrix of scalars
     combinations of a given matrix
     large integer random numbers */

  /**************************************************/
  /**** Monomial routines ***************************/
  /**************************************************/
  const MonomialOrNull *IM2_Monomial_var(int v, int e);

  const MonomialOrNull *IM2_Monomial_make(const M2_arrayint m);
    /* Takes an array of the form [n, v1, e1, v2, e2, ..., vn, en]
       and returns the monomial v1^e1*v2^e2*...vn^en.
       ASSUMPTION: v1 > v2 > ... > vn >= 0, each en is > 0. */

  M2_bool IM2_Monomial_is_equal(const Monomial *a, const Monomial *b);

  M2_bool IM2_Monomial_isequal(const Monomial *a, const Monomial *b); /*TO BE REMOVED */

  M2_bool IM2_Monomial_is_one(const Monomial *a);

  int IM2_Monomial_compare(const Monomial *a, const Monomial *b);

  M2_bool IM2_Monomial_divides(const Monomial *a, const Monomial *b);

  int IM2_Monomial_degree(const Monomial *a);

  const MonomialOrNull *IM2_Monomial_mult(const Monomial *a, 
					  const Monomial *b);

  const Monomial *IM2_Monomial_quotient(const Monomial *a, 
					const Monomial *b);

  const MonomialOrNull *IM2_Monomial_power(const Monomial *a, int n);

  const Monomial *IM2_Monomial_lcm(const Monomial *a, 
				   const Monomial *b);

  const Monomial *IM2_Monomial_gcd(const Monomial *a, 
				   const Monomial *b);

  const Monomial *IM2_Monomial_sat(const Monomial *a, 
				   const Monomial *b);

  const Monomial *IM2_Monomial_radical(const Monomial *a);

  const Monomial_pair *IM2_Monomial_syz(const Monomial *a, 
					const Monomial *b);

  unsigned long IM2_Monomial_hash(const Monomial *a);

  const M2_arrayint IM2_Monomial_to_arrayint(const Monomial *a);

  const M2_string IM2_Monomial_to_string(const Monomial *a);

  /**************************************************/
  /**** MonomialOrdering routines *******************/
  /**************************************************/
  MonomialOrdering *IM2_MonomialOrdering_lex(int nvars, int packing);
    /* Lex, LexSmall, LexTiny */

  MonomialOrdering *IM2_MonomialOrdering_grevlex(M2_arrayint degs, int packing);
    /* GRevLex, GrevLexSmall, GRevLexTiny */

  MonomialOrdering *IM2_MonomialOrdering_revlex(int nvars);
    /* RevLex => n */

  MonomialOrdering *IM2_MonomialOrdering_weights(M2_arrayint wts);
    /* Weights => {...} */

  MonomialOrdering *IM2_MonomialOrdering_laurent(int nvars);
    /* GroupLex => n */

  MonomialOrdering *IM2_MonomialOrdering_NClex(int nvars);
    /* NCLex => n */

  MonomialOrdering *IM2_MonomialOrdering_component(void);
    /* Component */

  MonomialOrdering *IM2_MonomialOrdering_product(MonomialOrdering_array mo);
    /* for tensor products */

  MonomialOrdering *IM2_MonomialOrdering_join(MonomialOrdering_array mo);
    /* default, when making monoids and polynomial rings */

  int IM2_MonomialOrdering_nvars(MonomialOrdering *mo);

  int IM2_MonomialOrdering_n_invertible_vars(MonomialOrdering *mo);

  M2_string IM2_MonomialOrdering_to_string(MonomialOrdering *mo);

  unsigned long IM2_MonomialOrdering_hash(MonomialOrdering *mo);
    /* Assigned sequentially */

  /**************************************************/
  /**** Monoid routines *****************************/
  /**************************************************/
  Monoid *IM2_Monoid_trivial(); 
    /* Always returns the same object */

  MonoidOrNull *IM2_Monoid_make(MonomialOrdering *mo,
				M2_stringarray names,
				Monoid *DegreeMonoid,
				M2_arrayint degs);
    /* This function will return NULL if the monomial order cannot be handled
       currently, if the first components for each degree are not all
       positive, or under various other "internal" error conditions */
  
  unsigned long IM2_Monoid_hash(Monoid *M); 
    /* Assigned sequentially */

  M2_string IM2_Monoid_to_string(Monoid *M); 
    /* For debugging purposes */

  /**************************************************/
  /**** Ring routines *******************************/
  /**************************************************/
  const Ring *IM2_Ring_ZZ(void); 
    /* always returns the same object */

  const Ring *IM2_Ring_QQ(void); 
    /* always returns the same object */

  unsigned long IM2_Ring_hash(const Ring *R); 
    /* assigned sequentially */

  M2_string IM2_Ring_to_string(const Ring *M);

  const RingOrNull *IM2_Ring_ZZp(int p, const Monoid *deg_monoid);
    /* Expects a prime number p in range 2 <= p <= 32749 */

  const RingOrNull *IM2_Ring_GF(const RingElement *f);
    /* f should be a primitive element in a ring
       R = ZZ/p[x]/(g(x)), some p, some variable x, g irreducible, 
       monic, deg >= 2.
       However, currently, NONE of this is checked...
    */

  const RingOrNull *IM2_Ring_RR(double precision, 
				const Monoid *deg_monoid);

  const RingOrNull *IM2_Ring_polyring(const Ring *K, 
				      const Monoid *M);

  const RingOrNull *IM2_Ring_skew_polyring(const Ring *K, 
					   const Monoid *M,
					   M2_arrayint skewvars); /* TODO */

  const RingOrNull *IM2_Ring_weyl_algebra(const Ring *K, 
					  const Monoid *M,
					  M2_arrayint comm_vars,
					  M2_arrayint diff_vars,
					  int homog_var);

  const Ring *IM2_Ring_frac(const Ring *R);

  const RingOrNull * IM2_Ring_quotient(const Ring *R, 
				       const Matrix *I); /* TODO */

  const RingOrNull * IM2_Ring_schur(const Ring *K, 
				    const Monoid *M);

  M2_bool IM2_Ring_is_field(const Ring *K);
    /* Returns true if K is a field, or has been declared to be one.
       In the latter case, if an operation shows that K cannot be a field,
       then this function will thereafter return false, and 
       IM2_Ring_get_zero_divisor(K) can be used to obtain a non-unit, if one
       has been found. */
  
  void IM2_Ring_declare_field(const Ring *K);
    /* Declare that K is a field.  The ring K can then be used as the coefficient
       ring for computing Groebner bases,etc.  */

  const RingElement * IM2_Ring_get_zero_divisor(const Ring *K);
    /* Return a non-unit for the ring K, if one has been found, or the zero
       element, if not. Perhaps we should name this 'get_non_unit'.  This
       function currently never seems to return a non-zero value, but I plan 
       on fixing that (MES, June 2002). */
  
  /**************************************************/
  /**** Ring element routines ***********************/
  /**************************************************/
  const RingElement *IM2_RingElement_from_Integer(const Ring *R, 
						  const M2_Integer d); 

  const RingElement *IM2_RingElement_from_double(const Ring *R, 
						 double d);

  const M2_Integer IM2_RingElement_to_Integer(const RingElement *a);
    /* If the ring of a is ZZ, or ZZ/p, this returns the underlying representation.
       Otherwise, NULL is returned, and an error is given */

  double IM2_RingElement_to_double(const RingElement *a); /* TODO */
    /* If the ring of a is RR, this returns the underlying representation of 'a'.
       Otherwise 0.0 is returned. */

  M2_BigReal IM2_RingElement_to_BigReal(const RingElement *a); /* TODO */
    /* If the ring of a is BigRR, this returns the underlying representation of 'a'.
       Otherwise NULL is returned. */

  const RingElementOrNull *IM2_RingElement_from_BigReal(const Ring *R, 
							const M2_BigReal d);
    /* TODO */

  const RingElementOrNull *IM2_RingElement_make_var(const Ring *R, 
						    int v, 
						    int e);

  M2_bool IM2_RingElement_is_zero(const RingElement *a);

  M2_bool IM2_RingElement_is_equal(const RingElement *a,
				   const RingElement *b);

  const RingElement *IM2_RingElement_negate(const RingElement *a);

  const RingElementOrNull *IM2_RingElement_add(const RingElement *a, 
					       const RingElement *b);

  const RingElementOrNull *IM2_RingElement_subtract(const RingElement *a, 
						    const RingElement *b);

  const RingElementOrNull *IM2_RingElement_mult(const RingElement *a, 
						const RingElement *b);

  const RingElementOrNull *IM2_RingElement_power(const RingElement *a, 
						 const M2_Integer n);
  
  const RingElementOrNull *IM2_RingElement_invert(const RingElement *a);/* TODO */

  const RingElementOrNull *IM2_RingElement_div(const RingElement *a, 
					       const RingElement *b);

  const RingElementOrNull *IM2_RingElement_mod(const RingElement *a, 
					       const RingElement *b);

  const RingElement_pair *IM2_RingElement_divmod(const RingElement *a, 
						 const RingElement *b);


  const M2_string IM2_RingElement_to_string(const RingElement *a);

  unsigned long IM2_RingElement_hash(const RingElement *a);/* TODO */

  const Ring * IM2_RingElement_ring(const RingElement *a);

  /**************************************************/
  /**** polynomial ring element routines ************/
  /**************************************************/

  M2_bool IM2_RingElement_is_graded(const RingElement *a);

  M2_arrayint_OrNull IM2_RingElement_multidegree(const RingElement *a);

  M2_Integer_pair_OrNull *IM2_RingElement_degree(const RingElement *a, 
						 const M2_arrayint wts);
    /* The first component of the degree is used, unless the degree monoid is trivial,
       in which case the degree of each variable is taken to be 1. 
       Returns lo,hi degree.  If the ring is not a graded ring or a polynomial ring
       then (0,0) is returned.
    */

  const RingElementOrNull *IM2_RingElement_homogenize_to_degree(
            const RingElement *a,
	    int v,
	    int deg,
	    const M2_arrayint wts);

  const RingElementOrNull *IM2_RingElement_homogenize(
            const RingElement *a,
	    int v,
	    const M2_arrayint wts);
						
  const RingElementOrNull *IM2_RingElement_term(
            const Ring *R,
	    const RingElement *a,
	    const Monomial *m);
    /* R must be a polynomial ring, and 'a' an element of the
       coefficient ring of R.  Returns a*m, if this is a valid
       element of R.  Returns NULL if not (with an error message). 
    */

  const RingElement *IM2_RingElement_get_terms(
            const RingElement *a,
	    int lo, int hi);
    /* Returns the sum of some monomials of 'a', starting at 'lo',
       going up to 'hi'.  If either of these are negative, they are indices 
       from the back of the polynomial.
       'a' should be an element of a polynomial ring. 
    */

  const RingElementOrNull *IM2_RingElement_get_coeff(
            const RingElement *a,
	    const Monomial *m);
    /* Return (as an element of the coefficient ring) the coeff
       of the monomial 'm'. 
    */

  const RingElement *IM2_RingElement_lead_coeff(const RingElement *a);

  const MonomialOrNull *IM2_RingElement_lead_monomial(const RingElement *a);

  int IM2_RingElement_n_terms(const RingElement *a);

  ArrayPairOrNull IM2_RingElement_list_form(const RingElement *f);

  /**************************************************/
  /**** fraction field ring element routines ********/
  /**************************************************/
  const RingElement *IM2_RingElement_numerator(const RingElement *a);

  const RingElement *IM2_RingElement_denominator(const RingElement *a);

  const RingElementOrNull *IM2_RingElement_fraction(const Ring *R,
						    const RingElement *a,
						    const RingElement *b);

  /**************************************************/
  /**** FreeModule routines *************************/
  /**************************************************/
  /* A FreeModule in the engine is always over a specific
     ring, and is graded using the degree monoid of the ring.
     Monomials in a free module are ordered, either in a way
     determined by the ordering in the ring, or using an induced
     (Schreyer) monomial ordering (in the case when the ring
     is a polynomial ring of some sort) */
  /* General notes: these are immutable obects, at least once
     they are returned by the engine */
  /* BUGS/TODO: the Schreyer orders produced by sum,tensor,
     symm,exterior, and submodule, ignore the current tie
     breaker values.
     Also: I might keep all freemodules for a ring unique.
     This is not currently done. */
  
  const Ring *
  IM2_FreeModule_ring(
          const FreeModule *F);

  int
  IM2_FreeModule_rank(
          const FreeModule *F);

  const M2_string 
  IM2_FreeModule_to_string(
          const FreeModule *F);

  const unsigned long int 
  IM2_FreeModule_hash(
          const FreeModule *F); /* TODO */

  const FreeModule *
  IM2_FreeModule_make(
          const Ring *R, 
	  int rank);

  const FreeModuleOrNull *
  IM2_FreeModule_make_degs(
          const Ring *R, 
	  M2_arrayint degs);
    /* Make a graded free module over R.  'degs' should be of length 
     * divisible by the length 'd' of a degree vector, and the 
     * i th degree will be degs[i*d]..degs[i*d+d-1], starting at
     * i = 0. 
     */
  
  const FreeModuleOrNull *
  IM2_FreeModule_make_schreyer(
          const Matrix *m);
    /* Returns G, (a copy of) the source free module of 'm', modified to
     * use the induced order via m: compare two monomials of G via
     * x^A e_i > x^B e_j iff either 
     * leadmonomial((in m)(x^A e_i)) > leadmonomial((in m)(x^B e_j))
     * or these are the same monomial, and i > j. 
     * The case where the target of 'm' has a Schreyer order is 
     * handled efficiently. 
     */

  const M2_arrayint 
  IM2_FreeModule_get_degrees(
          const FreeModule *F);

  const Matrix * 
  IM2_FreeModule_get_schreyer(
          const FreeModule *F);

  const M2_bool 
  IM2_FreeModule_is_equal(
          const FreeModule *F, 
	  const FreeModule *G);
    /* Determines if F and G are the same graded module.  If one has a
     * Schreyer order and one does not, but their ranks and degrees are the
     * same, then they are considered equal by this routine. 
     */

  const FreeModuleOrNull *
  IM2_FreeModule_sum(
          const FreeModule *F,
	  const FreeModule *G);
    /* The direct sum of two free modules over the same ring, or NULL.
     * If F or G has a Schreyer order, then so does their direct sum 
     */

  const FreeModuleOrNull * 
  IM2_FreeModule_tensor(
          const FreeModule *F,
	  const FreeModule *G);
    /* The tensor product of two free modules over the same ring, or NULL.
     * If F has (ordered basis {f_1,...,f_r}, and 
     * G has (ordered) basis {g_1, ..., g_s}, then
     * the result has (ordered) basis 
     *    {f_1 ** g_1, f_1 ** g_2, ..., f_1 ** g_s,
     *     f_2 ** g_1, f_2 ** g_2, ..., f_2 ** g_s,
     *     ...
     *     f_r ** g_1, ...              f_r ** g_s}.
     *  If F or G has a Schreyer order, what about their tensor product?
     *  At the moment, the answer is almost yes...
     */
  
  const FreeModule * 
  IM2_FreeModule_dual(
	  const FreeModule *F);
    /* Returns the graded dual F^* of F: if F has basis {f_1,...,f_r},
     * with degrees {d_1, ..., d_r}, then F^* has rank r, with
     * degrees {-d_1, ..., -d_r}.  The result does not have a 
     * Schreyer order (even if F does). 
     */

  const FreeModule * 
  IM2_FreeModule_symm(
          int n, 
	  const FreeModule *F);
    /* Returns the n th symmetric power G of F.
     * If F has basis {f_1,...,f_r}, then G has basis
     * the monomials of f_1, ..., f_r of degree exactly n, in
     * descending lexicographic order.
     * If F has a Schreyer order, then G is set to have one as well. 
     */


  const FreeModule * 
  IM2_FreeModule_exterior(
          int n, 
	  const FreeModule *F);
    /* Returns the n th exterior power G of F.
     * If F has basis {f_1,...,f_r}, then G has basis
     * the squarefree monomials of f_1, ..., f_r of degree exactly n, in
     * descending reverse lexicographic order.
     * If F has a Schreyer order, then G is set to have one as well. 
     */

  const FreeModuleOrNull * 
  IM2_FreeModule_submodule(
	  const FreeModule *F, 
	  M2_arrayint selection);
    /* Returns a free module obtained by choosing basis elements of F:
     * if F has basis {f_0, ..., f_(r-1)} with degrees {d_0, ..,d_(r-1)},
     * and selection = [i_1, ..., i_s], where 0 <= i_j < r for all j,
     * then return a free module of rank s, having degrees 
     * d_(i_1), ..., d_(i_s).  'selection' may include duplicate values.
     * If F has a Schreyer order, the result has one as well. 
     */
  
  /**************************************************/
  /**** Vector routines *****************************/
  /**************************************************/

  const FreeModule * 
  IM2_Vector_freemodule(
	  const Vector *v);
    /* The ambient free module of the vector v. */

  const RingElement_array * IM2_Vector_to_ringelements(const Vector *v);
    /* Returns an array of all of the components of the vector v. */

  const RingElementOrNull * IM2_Vector_component(const Vector *v, int i);
    /* The i th component (0..rank(F)-1), where F is the ambient free
       module of v. */

  const M2_string IM2_Vector_to_string(const Vector *v);

  unsigned long IM2_Vector_hash(const Vector *v); /* TODO */

  M2_bool IM2_Vector_is_zero(const Vector *a);

  M2_bool IM2_Vector_is_equal(const Vector *a,
			      const Vector *b);
    /* a and b will not be equal if their ambient free modules are not 
       identical (same pointers). */

  const VectorOrNull * IM2_Vector_make(const FreeModule *F, 
				       RingElement_array *v);
    /* Creates a vector in F from its dense representation in v.
       NULL is returned if the length is wrong, or the base rings are
       not all the same */

  const VectorOrNull * IM2_Vector_e_sub(const FreeModule *F, int i);

  const Vector * IM2_Vector_zero(const FreeModule *F);

  const Vector * IM2_Vector_negate(const Vector *v);

  const VectorOrNull * IM2_Vector_add(const Vector *v, 
				      const Vector *w);
  
  const VectorOrNull * IM2_Vector_subtract(const Vector *v, 
					   const Vector *w);

  const VectorOrNull * IM2_Vector_scalar_mult(const RingElement *r,
					      const Vector *v); /* TODO */

  const VectorOrNull * IM2_Vector_scalar_right_mult(const Vector *v,
						    const RingElement *r);

  const VectorOrNull *IM2_Vector_term(const FreeModule *F,
				      const RingElement *a,
				      int component);

  M2_bool IM2_Vector_is_graded(const Vector *a);

  M2_arrayint IM2_Vector_multidegree(const Vector *a);

  /**************************************************/
  /**** polynomial vector routines ******************/
  /**************************************************/

  M2_Integer_pair_OrNull *IM2_Vector_degree(const Vector *a, 
					    const M2_arrayint wts); /* TODO */
  /* The first component of the degree is used, unless the degree monoid is trivial,
     in which case the degree of each variable is taken to be 1. 
     Returns lo,hi degree.  If the ring is not a graded ring or a polynomial ring
     then (0,0) is returned.
  */

  const VectorOrNull *IM2_Vector_homogenize_to_degree(const Vector *a,
						int v,
						int deg,
						const M2_arrayint wts);

  const VectorOrNull *IM2_Vector_homogenize(const Vector *a,
					    int v,
					    const M2_arrayint wts);
						
  const Vector *IM2_Vector_get_terms(const Vector *a,
				     int lo, int hi);
    /* Returns the sum of some monomials of 'a', starting at 'lo',
       going up to 'hi'.  If either of these are negative, they are indices 
       from the end of the vector. */


  const RingElement *IM2_Vector_lead_coeff(const Vector *a);

  const MonomialOrNull *IM2_Vector_lead_monomial(const Vector *a); /* TODO */

  int IM2_Vector_lead_component(const Vector *a);

  int IM2_Vector_n_terms(const Vector *a);

  /**************************************************/
  /**** Matrix routines *****************************/
  /**************************************************/

  const FreeModule * IM2_Matrix_get_target(const Matrix *M);

  const FreeModule * IM2_Matrix_get_source(const Matrix *M);

  const M2_arrayint IM2_Matrix_get_degree(const Matrix *M);

  const M2_string IM2_Matrix_to_string(const Matrix *M);

  unsigned long  IM2_Matrix_hash(const Matrix *M); /* TODO */

  const RingElementOrNull * IM2_Matrix_get_element(const Matrix *M, int r, int c);

  const Vector * IM2_Matrix_get_column(const Matrix *M, int c);


  const MatrixOrNull * IM2_Matrix_make1(const FreeModule *target,
					const Vector_array *V);
  
  const MatrixOrNull * IM2_Matrix_make2(const FreeModule *target,
					const FreeModule *source,
					const M2_arrayint deg,
					const Vector_array *V);

  const MatrixOrNull * IM2_Matrix_make3(const FreeModule *target,
					const FreeModule *source,
					const M2_arrayint deg,
					const Matrix *M);

  const M2_bool IM2_Matrix_is_zero(const Matrix *M);

  const M2_bool IM2_Matrix_is_equal(const Matrix *M, 
				    const Matrix *N);
    /* This checks that the entries of M,N are the same, as well as
       that the source and target are the same (as graded free modules).
       Therefore, it can happen that M-N == 0, but M != N.
    */

  const M2_bool IM2_Matrix_is_graded(const Matrix *M);

  const MatrixOrNull * IM2_Matrix_add(const Matrix *M, const Matrix *N);
    /* If the sizes do not match, then NULL is returned.  If they do match,
       the addition is performed.  If the targets are not equal, the target 
       of the result is set to have each degree zero.  Similarly with the
       source, and also with the degree of the matrix. */

  const MatrixOrNull * IM2_Matrix_subtract(const Matrix *M, const Matrix *N);
    /* If the sizes do not match, then NULL is returned.  If they do match,
       the addition is performed.  If the targets are not equal, the target 
       of the result is set to have each degree zero.  Similarly with the
       source, and also with the degree of the matrix. */

  const Matrix * IM2_Matrix_negate(const Matrix *M);

  const MatrixOrNull * IM2_Matrix_mult(const Matrix *M, const Matrix *N);
    /* If the sizes do not match, then NULL is returned.  If they do match,
       the multiplication is performed, and the source and target are taken from N,M
       respectively.  The degree of the result is the sum of the two degrees */

  const MatrixOrNull * IM2_Matrix_scalar_mult(const RingElement *f,
					      const Matrix *M);

  const MatrixOrNull * IM2_Matrix_scalar_right_mult(const Matrix *M, 
						    const RingElement *f); /* TODO */

  const VectorOrNull * IM2_Matrix_scalar_mult_vec(const Matrix *M, 
						  const Vector *v);

  const MatrixOrNull * IM2_Matrix_concat(const Matrix_array *Ms);

  const MatrixOrNull * IM2_Matrix_direct_sum(const Matrix_array *Ms);

  const MatrixOrNull * IM2_Matrix_tensor(const Matrix *M,
					 const Matrix *N);

  const Matrix * IM2_Matrix_transpose(const Matrix *M);

  const MatrixOrNull * IM2_Matrix_reshape(const Matrix *M,
					  const FreeModule *F,
					  const FreeModule *G);

  const MatrixOrNull * IM2_Matrix_flip(const FreeModule *F,
				       const FreeModule *G);

  const MatrixOrNull * IM2_Matrix_submatrix(const Matrix *M,
					    const M2_arrayint rows,
					    const M2_arrayint cols);

  const MatrixOrNull * IM2_Matrix_submatrix1(const Matrix *M,
					     const M2_arrayint cols);

  const Matrix * IM2_Matrix_identity(const FreeModule *F);

  const MatrixOrNull * IM2_Matrix_zero(const FreeModule *F,
				       const FreeModule *G);

  const MatrixOrNull * IM2_Matrix_koszul(int p, const Matrix *M);

  const MatrixOrNull * IM2_Matrix_symm(int p, const Matrix *M);

  const Matrix * IM2_Matrix_exterior(int p, const Matrix *M, int strategy);

  const M2_arrayint IM2_Matrix_sort_columns(const Matrix *M, 
					    int deg_order, 
					    int mon_order);


  const Matrix * IM2_Matrix_minors(int p, const Matrix *M, int strategy);
  
  const MatrixOrNull * IM2_Matrix_pfaffians(int p, const Matrix *M);

  const MatrixOrNull * IM2_Matrix_compress(const Matrix *M); /* TODO */

  const MatrixOrNull * IM2_Matrix_uniquify(const Matrix *M); /* TODO */

  const MatrixOrNull * IM2_Matrix_remove_content(const Matrix *M);

  /* Routines for use when the base ring is a polynomial ring of some sort */

  const MatrixOrNull * IM2_Matrix_diff(const Matrix *M,
				       const Matrix *N);

  const MatrixOrNull * IM2_Matrix_contract(const Matrix *M,
					   const Matrix *N);

  const MatrixOrNull * IM2_Matrix_homogenize(const Matrix *M,
					     int var,
					     M2_arrayint wts);

  const Matrix_pair_OrNull * IM2_Matrix_coeffs(const Matrix *M, M2_arrayint vars) ;/* TODO */

  const MatrixOrNull * IM2_Matrix_get_coeffs(const M2_arrayint vars,
					     const M2_arrayint monoms,
					     const Matrix *M);
  /* Given a list of variable indices, 'vars', and a flattened list of exponent vectors 'monoms'
     each exponent vector of length = #vars, AND a matrix with one row, returns a matrix
     of size #monoms/#vars by #cols(M), where the i th column consists of the polynomials
     in the other variables which is the coeff of the i th monomial in monoms.
     WARNING DAN: this has never been run before (new routine).  In particular,
     should the second argument instead be a one row matrix, and the monoms are the lead 
     exponent vectors of the columns?? */

  const MatrixOrNull * IM2_Matrix_monomials(const M2_arrayint vars, const Matrix *M);

  const Matrix * IM2_Matrix_initial(int nparts, const Matrix *M);

  const M2_arrayint IM2_Matrix_elim_vars(int nparts, const Matrix *M);

  const M2_arrayint IM2_Matrix_keep_vars(int nparts, const Matrix *M);

  Matrix_int_pair * IM2_Matrix_divide_by_var(const Matrix *M, int var, int maxdegree);
  /* If M = [v1, ..., vn], and x = 'var'th variable in the ring, 
     return the matrix [w1,...,wn], where wi * x^(ai) = vi,
     and wi is not divisible by x, or ai = maxdegree, 
     and the integer which is the maximum of the ai's.
     QUESTION: what rings should this work over?
  */

  M2_arrayint IM2_Matrix_min_leadterms(const Matrix *M, M2_arrayint vars); /* TODO */

  const MatrixOrNull * IM2_Matrix_auto_reduce(const Matrix *M); /* TODO */
  
  const MatrixOrNull * IM2_Matrix_reduce(const Matrix *M, const Matrix *N); /* TODO */

  const MatrixOrNull * IM2_Matrix_reduce_by_ideal(const Matrix *M, const Matrix *N); /* TODO */

  /* Routines when considering matrices as modules of some sort */

  const MatrixOrNull * IM2_Matrix_module_tensor(const Matrix *M,
						const Matrix *N); /* TODO */

  const MatrixOrNull * IM2_Matrix_kbasis(const Matrix *M,
					 const Matrix *N,
					 M2_arrayint lo_deg,
					 M2_arrayint hi_deg); /* TODO */

  const MatrixOrNull * IM2_Matrix_kbasis_all(const Matrix *M,
					     const Matrix *N); /* TODO */

  const MatrixOrNull * IM2_Matrix_truncate(const Matrix *M,
					   const Matrix *N,
					   M2_arrayint deg); /* TODO */

  int IM2_Matrix_dimension(const Matrix *M); /* TODO */

  const RingElementOrNull * IM2_Matrix_Hilbert(const Matrix *M);
  /* This routine computes the numerator of the Hilbert series
     for coker leadterms(M), using the degrees of the rows of M. 
     NULL is returned if the ring is not appropriate for
     computing Hilbert series, or the computation was interrupted. */
  /* BUG: currently (7/18/2002), the result will be put into a ring ZZ[D],
     which is set for each ring by the engine.  This needs to change...! */

  /**************************************************/
  /**** RingMap routines ****************************/
  /**************************************************/
  /* My plan, Dan, is to make changes to how ring maps are
     constructed, in the case when we have rings over polynomials
     rings (including galois field bases) */

  const Ring * IM2_RingMap_target(const RingMap *F);

  const M2_string IM2_RingMap_to_string(const RingMap *F);

  const unsigned long int IM2_RingMap_hash(const RingMap *F); /* TODO */

  const M2_bool IM2_RingMap_is_equal(const RingMap*, const RingMap*); /* TODO (added by Dan) */

  const RingMap * IM2_RingMap_make(const Matrix *M, const Ring *base); /* TODO */

  const RingMap * IM2_RingMap_make1(const Matrix *M);
  /* WARNING: I want to change the interface to this routine */

  const RingElementOrNull * IM2_RingMap_eval_ringelem(const RingMap *F, 
						      const RingElement *a);

  const VectorOrNull * IM2_RingMap_eval_vector(const RingMap *F, 
					       const FreeModule *newTarget,
					       const Vector *v);

  const MatrixOrNull * IM2_RingMap_eval_matrix(const RingMap *F, 
					       const FreeModule *newTarget,
					       const Matrix *M);

  const RingElement *IM2_RingElement_promote(const Ring *S, const RingElement *f);

  const RingElement *IM2_RingElement_lift(const Ring *S, const RingElement *f);

    /* Is this documentation correct for promote and lift?
       We have several ways of moving from one ring to the next:
       R ---> R[x1..xn]
       R ---> R/I
       R ---> frac R
       Z/p[x]/F(x) ---> GF(p,n)
       R ---> local(R,I)    (much later...)
       
       Both of the following routines assume that S ---> 'this'
       is one of these construction steps.  Promote takes an element of
       S, and maps it into 'this', while lift goes the other way.
    */

  /**************************************************/
  /**** MutableMatrix routines **********************/
  /**************************************************/

  MutableMatrix * IM2_MutableMatrix_make(const Ring *R,
					 int nrows,
					 int ncols);

  MutableMatrix * IM2_MutableMatrix_from_matrix(const Matrix *M);

  MutableMatrix * IM2_MutableMatrix_iden(const Ring *R, int nrows);

  const Matrix * IM2_MutableMatrix_to_matrix(const MutableMatrix *M);

  const M2_string IM2_MutableMatrix_to_string(const MutableMatrix *M);

  unsigned long  IM2_MutableMatrix_hash(const MutableMatrix *M); /* TODO */

  int IM2_MutableMatrix_n_rows(const MutableMatrix *M);

  int IM2_MutableMatrix_n_cols(const MutableMatrix *M);

  MutableMatrix * IM2_MutableMatrix_get_row_change(MutableMatrix *M);

  MutableMatrix * IM2_MutableMatrix_get_col_change(MutableMatrix *M);

  void IM2_MutableMatrix_set_row_change(MutableMatrix *M,
					MutableMatrix *rowChange);

  void IM2_MutableMatrix_set_col_change(MutableMatrix *M,
					MutableMatrix *colChange);
  
  const RingElement * IM2_MutableMatrix_get_entry(const MutableMatrix *M, int r, int c);

  VoidOrError IM2_MutableMatrix_set_entry(MutableMatrix *M, int r, int c, const RingElement *a);

  void IM2_MutableMatrix_row_swap(MutableMatrix *M, int r1, int r2);

  void IM2_MutableMatrix_column_swap(MutableMatrix *M, int c1, int c2);

  VoidOrError IM2_MutableMatrix_row_change(MutableMatrix *M, int row_to_change, const RingElement *a, int r);
  /* Add a times row r to row 'row_to_change' */

  VoidOrError IM2_MutableMatrix_column_change(MutableMatrix *M, int col_to_change, const RingElement *a, int c);
  /* Add a times column c to column 'col_to_change' */

  VoidOrError IM2_MutableMatrix_row_scale(MutableMatrix *M, int row_to_change, const RingElement *a);
  /* Multiply row 'row_to_change' by a, on the left */

  VoidOrError IM2_MutableMatrix_column_scale(MutableMatrix *M, int col_to_change, const RingElement *a);
  /* Multiply column 'col_to_change' by a, on the left */

  /* There are more mutable matrix routines: delete row/column, insert rows/columns,
     find good pivots... What else? */

  /**************************************************/
  /**** Monomial ideal routines *********************/
  /**************************************************/

  /* A MonomialIdeal is an immutable object, having a base ring.
     The base ring should be a polynomial ring or quotient of one.
     In case a quotient is given, the monomial ideal is considered
     to be in the commutative quotient ring whose quotient elements
     are the lead terms of the quotient polynomials.
     Each monomial ideal is represented by its minimal generators only */

  const MonomialIdealOrNull *IM2_MonomialIdeal_make(const Matrix *m, int n);
  /* Given a matrix 'm' over an allowed base ring (as above), create the
     monomial ideal consisting of all of the lead monomials of the columns
     of 'm' which have their lead term in row 'n'.  If 'n' is out of range,
     or the ring is not allowed, NULL is returned. */

  const Matrix *IM2_MonomialIdeal_to_matrix(const MonomialIdeal *I);
  /* Return a one row matrix over the base ring of I consisting
     of the monomials in I */

  M2_string IM2_MonomialIdeal_to_string(const MonomialIdeal *I); /* TODO */

  unsigned long IM2_MonomialIdeal_hash(const MonomialIdeal *I);/* TODO */

  M2_bool IM2_MonomialIdeal_is_equal(const MonomialIdeal *I1, 
				     const MonomialIdeal *I2);

  int IM2_MonomialIdeal_n_gens(const MonomialIdeal *I);
  /* Returns the number of minimal generators of I */

  
  const MonomialIdeal *IM2_MonomialIdeal_radical(const MonomialIdeal *I);
  /* The radical of the monomial ideal, that is, the monomial ideal 
     generated by the square-free parts of the each monomial of I. */

  const MonomialIdealOrNull *IM2_MonomialIdeal_add(const MonomialIdeal *I, 
						   const MonomialIdeal *J);

  const MonomialIdealOrNull *IM2_MonomialIdeal_product(const MonomialIdeal *I, 
						       const MonomialIdeal *J);

  const MonomialIdealOrNull *IM2_MonomialIdeal_intersect(const MonomialIdeal *I, 
							 const MonomialIdeal *J);
  
  const MonomialIdeal *IM2_MonomialIdeal_quotient1(const MonomialIdeal *I, 
						   const Monomial *a);
  /* If I = (m1, ..., mr),
     Form the monomial ideal (I : a) = (m1:a, ..., mr:a) */

  const MonomialIdealOrNull *IM2_MonomialIdeal_quotient(const MonomialIdeal *I, 
							const MonomialIdeal *J);
  /* Form the monomial ideal (I : J) = intersect(I:m1, ..., I:mr),
     where J = (m1,...,mr) */

  const MonomialIdeal *IM2_MonomialIdeal_sat1(const MonomialIdeal *I, 
					      const Monomial *a);
  /* Form I:a^\infty.  IE, set every variable which occurs in 'a' to '1' in
     every generator of I. */

  const MonomialIdealOrNull *IM2_MonomialIdeal_sat(const MonomialIdeal *I,
						   const MonomialIdeal *J);
  /* Form (I : J^\infty) = intersect(I:m1^\infty, ..., I:mr^\infty),
     where J = (m1,...,mr). */

  const MonomialIdeal *IM2_MonomialIdeal_borel(const MonomialIdeal *I);
  /* This should really be named: ..._strongly_stable.
     Form the smallest monomial ideal J containing I which is strongly stable,
     that is that:
     If m is in J, then p_ij(m) is in J,
     where p_ij(m) = x_j * (m/x_i), for j <= i, s.t. x_i | m. (Here the
     variables in the ring are x1, ..., xn */

  M2_bool IM2_MonomialIdeal_is_borel(const MonomialIdeal *I);
  /* This should really be named: ..._is_strongly_stable.
     Determine if I is strongly stable (see IM2_MonomialIdeal_borel for the
     definition of strongly stable */

  int IM2_MonomialIdeal_codim(const MonomialIdeal *I);
  /* Return the codimension of I IN THE AMBIENT POLYNOMIAL RING. */

  const MonomialIdeal *IM2_MonomialIdeal_assprimes(const MonomialIdeal *I);
  /* RENAME THIS ROUTINE */
  /* Return a monomial ideal whose generators correspond to the 
     minimal primes of I of maximal dimension.  If a minimal prime
     of I has the form (x_i1, ..., x_ir), then the corresponding monomial
     is x1 ... xn /(x_i1 ... x_ir), i.e. the complement of the support of
     the monomial generates the monomial minimal prime. */

#if 0
  Monomial *IM2_MonomialIdeal_remove(MonomialIdeal *I); /* CAN WE REMOVE THIS?? */
  MonomialIdeal *IM2_MonomialIdeal_copy(MonomialIdeal *I); /* and THIS? */
#endif

  /**************************************************/
  /**** Groebner basis routines *********************/
  /**************************************************/
#if 0
  IM2_GB_setup(const Matrix *m, ...);

  IM2_GB_force(const Matrix *m, ...);

  IM2_GB_remove(const Matrix *m, ...);

  IM2_GB_compute(const Matrix *m, ..., ...);

  const Matrix *IM2_GB_get(const Matrix *m);

  const Matrix *IM2_GB_get_mingens(const Matrix *m);

  const Matrix *IM2_GB_get_syz(const Matrix *m);

  const Matrix *IM2_GB_get_change(const Matrix *m);

  const Matrix *IM2_GB_get_leadterms(int nparts, const Matrix *m);

  ... IM2_GB_get_status(const Matrix *m);

  const Matrix *IM2_GB_matrix_normal_form(const Matrix *m);

  const Vector *IM2_GB_vec_normal_form(const Vector *v);

  const MatrixPair *IM2_GB_matrix_lift(const Matrix *m);

  const VectorPair *IM2_GB_vec_lift(const Vector *v);
#endif

  /**************************************************/
  /**** Fraction free LU decomposition **************/
  /**************************************************/

  M2_arrayint_OrNull IM2_FF_LU_decomp(MutableMatrix *M);

#if defined(__cplusplus)
}
#endif

#endif
