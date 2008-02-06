---------------------------------------------------------------------------
-- PURPOSE : Methods for Janet bases and Pommaret bases
--           (as particular cases of involutive bases)
-- PROGRAMMER : Daniel Robertz
-- UPDATE HISTORY : 3 January 2008
-- (tested with Macaulay 2, version 0.9.95)
---------------------------------------------------------------------------
newPackage(
        "InvolutiveBases",
        Version => "1.0", 
        Date => "January 3, 2008",
        Authors => {{Name => "Daniel Robertz", 
                  Email => "daniel@momo.math.rwth-aachen.de", 
                  HomePage => "http://wwwb.math.rwth-aachen.de/~daniel/"}},
        Headline => "Methods for Janet bases and Pommaret bases in Macaulay 2",
        DebuggingMode => true
        )

export {basisElements, multVar, janetMultVar, pommaretMultVar, janetBasis, InvolutiveBasis,
     isPommaretBasis, invReduce, invSyzygies, invResolution}

----------------------------------------------------------------------
-- type InvolutiveBasis
----------------------------------------------------------------------

InvolutiveBasis = new Type of HashTable

basisElements = method()

basisElements(InvolutiveBasis) := J -> (
     return J#0;
     )

multVar = method()

multVar(InvolutiveBasis) := J -> (
     return J#1;
     )


----------------------------------------------------------------------
-- subroutines (not exported)
----------------------------------------------------------------------

-- determine multiplicative variables for list of
-- exponents exp2 with respect to Janet division
-- (exp1 is list of exponents of monomial which is
-- lexicographically next greater than that with exp2,
-- and has multiplicative variables specified by mult1)

janetDivision = (exp1, exp2, mult1) -> (
     n := length(exp1);
     k := 0;
     mult2 := {};
     while (k < n and exp1#k == exp2#k) do (
	  mult2 = append(mult2, mult1#k);
	  k = k+1;
     );
     if k == n then error "list of polynomials is not autoreduced";
     mult2 = append(mult2, 0);
     k = k+1;
     while k < n do (
	  mult2 = append(mult2, 1);
	  k = k+1;
     );
     return mult2;
     )


-- determine multiplicative variables for list of
-- exponents exp2 with respect to Pommaret division

pommaretDivision = (expon) -> (
     n := length(expon);
     k := n-1;
     mult := {};
     while (k >= 0 and expon#k == 0) do (
	  mult = prepend(1, mult);
	  k = k-1;
     );
     if k >= 0 then ( mult = prepend(1, mult); k = k-1; );
     while k >= 0 do (
	  mult = prepend(0, mult);
	  k = k-1;
     );
     return mult;
     )


-- decide whether or not list of exponents exp1 (with multiplicative
-- variables specified by mult1) is an involutive divisor of exp2

involutiveDivisor = (exp1, exp2, mult1) -> (
     for i from 0 to length(exp1)-1 do (
	  if (exp1#i > exp2#i or (exp1#i < exp2#i and mult1#i == 0)) then return false;
     );
     return true;
     )


-- given a list L of (leading) monomials, return list of their
-- multiplicative variables with respect to Janet division

janetMultVarMonomials = L -> (
     R := ring L#0;
     F := coefficientRing R;
     v := generators R;
     n := length v;
     S := F[v, MonomialOrder=>Lex];
     M := matrix { for i in L list substitute(i, S) };
     p := reverse sortColumns M;
     mult := for i in v list 1;
     J := { hashTable(for j from 0 to n-1 list v#j => mult#j) } |
          for i from 1 to length(L)-1 list (
	       mult = janetDivision(
		    (exponents (entries M_(p#(i-1)))#0)#0,
		    (exponents (entries M_(p#i))#0)#0,
		    mult);
	       hashTable(for j from 0 to n-1 list v#j => mult#j)
	       );
     p = for i from 0 to length(p)-1 list position(p, j -> j==i);
     use R;
     return for i from 0 to length(p)-1 list J#(p#i);
     )


-- given a monomial m in a polynomial ring with n variables,
-- return the class of m

monomialClass = (m, n) -> (
     -- alternatively, use 'support' and 'index'
     expon := (exponents m)#0;
     k := n-1;
     while (k >= 0 and expon#k == 0) do ( k = k-1; );
     return k;
     )


-- subroutine used by invResolution,
-- sorts Janet basis such that iterated syzygy computation is
-- possible (schreyerOrder depends on this order of the
-- involutive basis)

sortByClass = J -> (
     R := ring J#0;
     v := generators R;
     n := length v;
     mult := J#1;
     L := leadTerm J#0;
     L = for i from 0 to (numgens source L)-1 list
          { leadMonomial sum entries L_i, leadComponent L_i };
     p := toList(0..(length(mult)-1));
     F := coefficientRing R;
     S := F[v, MonomialOrder=>Lex];
     modified := true;
     while modified do (
	  modified = false;
	  for i from 1 to length(p)-1 do
	       if (L#(p#i)#1 < L#(p#(i-1))#1 or (L#(p#i)#1 == L#(p#(i-1))#1 and
		  (monomialClass(L#(p#i)#0, n) < monomialClass(L#(p#(i-1))#0, n) or
		  (monomialClass(L#(p#i)#0, n) == monomialClass(L#(p#(i-1))#0, n) and
		   substitute(L#(p#i)#0, S) > substitute(L#(p#(i-1))#0, S))))) then (
	          p = for j from 0 to length(p)-1 list (
		       if j == i-1 then
		          p#i
		       else if j == i then
		          p#(i-1)
		       else
		          p#j
	          );
	          modified = true;
	       );
     );
     use R;
     return new InvolutiveBasis from hashTable {0 => submatrix(J#0, p),
          1 => for i from 0 to length(p)-1 list mult#(p#i)};
     )


----------------------------------------------------------------------
-- main routines
----------------------------------------------------------------------

-- given a matrix M of polynomials, return the list of hash tables
-- specifying the multiplicative variables for each column of M
-- with respect to Janet division

-- given a list L of polynomials, do the same for the matrix formed
-- by L as its only row

janetMultVar = method()

janetMultVar(Matrix) := M -> (
     R := ring M;
     F := coefficientRing R;
     v := generators R;
     n := length v;
     S := F[v, MonomialOrder=>{Position=>Up, Lex}];
     L := substitute(leadTerm M, S);
     p := reverse sortColumns L;
     J := for i from 0 to length(p)-1 list
          { leadMonomial sum entries L_(p#i), leadComponent L_(p#i) };
     -- select generators according to their leading component
     J = for i from 0 to (numgens target M)-1 list
	  select(J, j -> j#1 == i);
     local mult;
     J = flatten for k from 0 to (numgens target M)-1 list (
          mult = for i in v list 1;
          { hashTable(for j from 0 to n-1 list v#j => mult#j) } |
          for i from 1 to length(J#k)-1 list (
	       mult = janetDivision(
		    (exponents J#k#(i-1)#0)#0,
		    (exponents J#k#i#0)#0,
		    mult);
	       hashTable(for j from 0 to n-1 list v#j => mult#j)
	       )
	  );
     p = for i from 0 to length(p)-1 list position(p, j -> j==i);
     use R;
     return for i from 0 to length(p)-1 list J#(p#i);
     )

janetMultVar(List) := L -> (
     return janetMultVar(matrix {L});
     )


-- given a matrix M of polynomials, return the list of hash tables
-- specifying the multiplicative variables for each column of M
-- with respect to Pommaret division

-- given a list L of polynomials, do the same for the matrix formed
-- by L as its only row

pommaretMultVar = method()

pommaretMultVar(Matrix) := M -> (
     v := generators ring M;
     n := length v;
     local mult;
     return for i from 0 to (numgens source M)-1 list (
	  mult = pommaretDivision((exponents leadMonomial sum entries leadTerm M_i)#0);
          hashTable(for j from 0 to n-1 list v#j => mult#j)
          );
     )

pommaretMultVar(List) := L -> (
     return pommaretMultVar(matrix {L});
     )


-- given a (minimal) Groebner basis G for a submodule of a
-- free module over a polynomial ring, return a (minimal)
-- Janet basis for the same submodule
-- (up to now, it is not tail-reduced), that is a sequence
-- (matrix, list of hash tables specifying the
-- multiplicative variables for each column)

janetBasis = method()

janetBasis(GroebnerBasis) := G -> (
     M := generators G;
     R := ring M;
     v := generators R;
     M = for i from 0 to (numgens target M)-1 list
          submatrix(M, select(toList(0..(numgens source M)-1),
		    j -> leadComponent leadTerm M_j == i));
     local J;
     local N;
     local P;
     local Q;
     M = for c from 0 to length(M)-1 list (
	  N = M#c;
	  if numgens source N == 0 then continue;
	  -- leading monomials are all in c-th row
	  J = janetMultVarMonomials for i in flatten entries N^{c} list leadMonomial i;
	  P = flatten for i from 0 to length(J)-1 list (
	       for j in v list (
		    if J#i#j == 1 then continue;
		    j * N_{i}
		    )
	       );
	  P = for i in P list (
	       if length(select(toList(0..length(J)-1),
		    j -> involutiveDivisor(
		    (exponents leadMonomial (entries N^{c}_j)#0)#0,
		    (exponents leadMonomial (entries i^{c})#0#0)#0,
		    for k in v list J#j#k))) > 0 then continue;
	       i
	       );
	  while length(P) > 0 do (
	       Q = P#0;
	       for i from 1 to length(P)-1 do Q = Q | P#i;
	       N = N | matrix { (sort Q)_0 };
	       J = janetMultVarMonomials for i in flatten entries N^{c} list leadMonomial i;
	       P = flatten for i from 0 to length(J)-1 list (
		    for j in v list (
			 if J#i#j == 1 then continue;
			 j * N_{i}
			 )
		    );
	       P = for i in P list (
		    if length(select(toList(0..length(J)-1),
			 j -> involutiveDivisor(
			 (exponents leadMonomial (entries N^{c}_j)#0)#0,
			 (exponents leadMonomial (entries i^{c})#0#0)#0,
			 for k in v list J#j#k))) > 0 then continue;
		    i
		    );
	  );
          (N, J)
     );
     p := sortColumns M#0#0;
     P = submatrix(M#0#0, p);
     J = for j from 0 to length(p)-1 list M#0#1#(p#j);
     for i from 1 to length(M)-1 do (
	  p = sortColumns M#i#0;
	  P = P | submatrix(M#i#0, p);
	  J = J | for j from 0 to length(p)-1 list M#i#1#(p#j);
     );
     return new InvolutiveBasis from hashTable {0 => P, 1 => J};
     )


-- given a Janet basis J for a submodule of a free module
-- over a polynomial ring, as returned by janetBasis, decide
-- whether or not it is also a Pommaret basis for the same module

isPommaretBasis = method()

isPommaretBasis(InvolutiveBasis) := J -> (
     v := generators ring J#0;
     P := pommaretMultVar J#0;
     for i from 0 to length(J#1)-1 do (
	  for j in v do (
	       if J#1#i#j != P#i#j then return false;
          );
     );
     return true;
     )


-- given a Janet basis J for a submodule of a free module
-- over a polynomial ring and an element p of this free module,
-- return the normal form of p modulo the Janet basis and the
-- coefficients used for the involutive reduction
-- (more precisely, we have p = r + J#0 * c,
-- where (r, c) is the result of invReduce, and * is
-- matrix multiplication)

invReduce = method()

invReduce(Matrix,InvolutiveBasis) := (p, J) -> (
     R := ring J#0;
     v := generators R;
     L := leadTerm J#0;
     L = for i from 0 to (numgens source L)-1 list
          { leadMonomial sum entries L_i,
	    leadComponent L_i,
	    leadCoefficient sum entries L_i };
     zl := 0*(target p)_0;
     zr := 0*(R^(length L))_0;
     local i;
     local c;
     local f;
     local lc;
     local lm;
     local lt;
     local m;
     local q;
     local r;
     L = for j from 0 to (numgens source p)-1 list (
	  q = p_j;
	  r = zl;
	  c = zr;
	  f = (v#0)^0;  -- equals 1
	  while matrix {q} != 0 do (
	       lt = leadTerm q;
	       m = leadComponent lt;
	       lc = leadCoefficient sum flatten entries lt;
	       lm = leadMonomial sum flatten entries lt;
	       i = 0;
	       while i < length(L) do (
		    if (m == L#i#1) and involutiveDivisor(
			 (exponents L#i#0)#0,
			 (exponents lm)#0,
			 for k in v list J#1#i#k) then break;
		    i = i + 1;
	       );
	       if i < length(L) then (
		    -- didn't work without "substitute" for coefficients in finite fields
		    q = substitute(L#i#2, R) * q - lc * (lm // L#i#0) * J#0_i;
		    c = c + lc * (lm // L#i#0) * (R^(length L))_i;
		    r = substitute(L#i#2, R) * r;
		    f = L#i#2 * f;
	       )
	       else (
		    q = q - lt;
		    r = r + lt;
	       );
	  );
          r = apply(r, i -> i // f);
          c = apply(c, i -> i // f);
          (r, c)
     );
     N := matrix { L#0#0 };
     C := matrix { L#0#1 };
     for j from 1 to length(L)-1 do (
	  N = N | matrix { L#j#0 };
	  C = C | matrix { L#j#1 };
     );
     return (N, C);
     )

invReduce(RingElement,InvolutiveBasis) := (p, J) -> (
     return invReduce(matrix {{p}}, J);
     )


-- given a Janet basis J for a submodule of a free module
-- over a polynomial ring, as returned by janetBasis, return
-- Janet basis for the syzygies of J;
-- caveat: cannot be iterated because schreyerOrder is not used
-- (see invResolution)

invSyzygies = method()

invSyzygies(InvolutiveBasis) := J -> (
     bas := J#0;
     mult := J#1;
     R := ring bas;
     v := generators R;
     zl := 0*(target bas)_0;
     local r;
     S := flatten for i from 0 to (numgens source bas)-1 list (
	  for j in v list (
	       if mult#i#j == 1 then continue;
               r = invReduce(j * bas_{i}, J);
	       if (r#0)_0 != zl then error "given data is not a Janet basis";
	       r = matrix { j * (R^(length(mult)))_i } - r#1;
	       (r, hashTable(for k in v list if k <= j then ( k => 1 ) else ( k => mult#i#k )))
	  )
     );
     if length(S) > 0 then (
	  M := S#0#0;
	  L := { S#0#1 };
	  for j from 1 to length(S)-1 do (
	       M = M | S#j#0;
	       L = L | { S#j#1 };
	  );
          return new InvolutiveBasis from hashTable {0 => M, 1 => L};
     )
     else (
          return new InvolutiveBasis from
	       hashTable {0 => matrix(R, apply(length(mult), i -> {})), 1 => {}};
     );
     )


-- given a Janet basis for a submodule of a free module
-- over a polynomial ring, as returned by janetBasis, construct
-- a free resolution R for this module: R is a list of InvolutiveBasis
-- such that R#i is a Janet basis for the i-th syzygies

invResolution = method()

invResolution(InvolutiveBasis) := J -> (
     R := { sortByClass(J) };
     S := invSyzygies R#(-1);
     S = (map(source schreyerOrder leadTerm R#(-1)#0, source S#0, S#0), S#1);
     while length(S#1) > 0 do (
	  R = R | { sortByClass(S) };
	  S = invSyzygies R#(-1);
          S = (map(source schreyerOrder leadTerm R#(-1)#0, source S#0, S#0), S#1);
     );
     return R;
     )


----------------------------------------------------------------------
-- documentation
----------------------------------------------------------------------

beginDocumentation()

document { 
        Key => InvolutiveBases,
        Headline => "Methods for Janet bases and Pommaret bases in Macaulay 2",
        EM "InvolutiveBases", " is a package which provides routines for dealing with Janet and Pommaret bases.",
	PARA{
             "Janet bases can be constructed from given Groebner bases. It can be checked whether a Janet basis is a Pommaret basis. Involutive reduction modulo a Janet basis can be performed. Syzygies and free resolutions can be computed using Janet bases."
	    },
	PARA{
             "Some references:"
	    },
	UL {
	     "J. Apel, The theory of involutive divisions and an application to Hilbert function computations. J. Symb. Comp. 25(6), 1998, pp. 683-704.",
             TEX "V. P. Gerdt, Involutive Algorithms for Computing Gr\\\"obner Bases. In: Cojocaru, S. and Pfister, G. and Ufnarovski, V. (eds.), Computational Commutative and Non-Commutative Algebraic Geometry, NATO Science Series, IOS Press, pp. 199-225.",
             "V. P. Gerdt and Y. A. Blinkov, Involutive bases of polynomial ideals. Minimal involutive bases. Mathematics and Computers in Simulation 45, 1998, pp. 519-541 resp. 543-560.",
             "M. Janet, Lecons sur les systemes des equationes aux derivees partielles. Cahiers Scientifiques IV. Gauthiers-Villars, Paris, 1929.",
             "J.-F. Pommaret, Partial Differential Equations and Group Theory. Kluwer Academic Publishers, 1994.",
             "W. Plesken and D. Robertz, Janet's approach to presentations and resolutions for polynomials and linear pdes. Archiv der Mathematik 84(1), 2005, pp. 22-37.",
             "W. M. Seiler, A Combinatorial Approach to Involution and delta-Regularity: I. Involutive Bases in Polynomial Algebras of Solvable Type. II. Structure Analysis of Polynomial Modules with Pommaret Bases. Preprints, arXiv:math/0208247 and arXiv:math/0208250."
           }
        }

document {
        Key => {basisElements,(basisElements,InvolutiveBasis)},
        Headline => "extract the matrix of generators from a Janet basis",
        Usage => "basisElements J",
        Inputs => {{ "J, ", ofClass InvolutiveBasis, ", a Janet basis as returned by ", TO "janetBasis" }},
        Outputs => {{ ofClass Matrix, ", the columns are generators for the module spanned by J" }},
        EXAMPLE lines ///
          R = QQ[x,y]
	  I = ideal(x^3,y^2)
	  G = gb I
	  J = janetBasis G;
	  basisElements J
        ///,
        SeeAlso => {janetBasis,multVar}
        }

document {
        Key => {multVar,(multVar,InvolutiveBasis)},
        Headline => "extract the table of multiplicative variables from a Janet basis",
        Usage => "multVar J",
        Inputs => {{ "J, ", ofClass InvolutiveBasis, ", a Janet basis as returned by ", TO "janetBasis" }},
        Outputs => {{ "list of HashTable; the i-th hash table specifies which variables of the polynomial ring are multiplicative for the i-th generator in J; a value of 0 or 1 is assigned to each variable of the polynomial ring; 1 means the variable is multiplicative, 0 indicates a non-multiplicative variable" }},
        EXAMPLE lines ///
          R = QQ[x,y]
	  I = ideal(x^3,y^2)
	  G = gb I
	  J = janetBasis G;
	  multVar J
        ///,
        SeeAlso => {janetBasis,janetMultVar,pommaretMultVar,basisElements}
        }

document {
        Key => {janetBasis,(janetBasis,GroebnerBasis)},
        Headline => "compute Janet basis from a given Groebner basis",
        Usage => "janetBasis G",
        Inputs => {{ "G, ", ofClass GroebnerBasis }},
        Outputs => {{ ofClass InvolutiveBasis }},
        EXAMPLE lines ///
          R = QQ[x,y]
	  I = ideal(x^3,y^2)
	  G = gb I
	  J = janetBasis G;
	  basisElements J
	  multVar J
        ///,
        EXAMPLE lines ///
	  R = QQ[x,y]
	  M = matrix {{x*y-y^3, x*y^2, x*y-x}, {x, y^2, x}}
	  G = gb M
	  J = janetBasis G;
	  basisElements J
	  multVar J
        ///,
        SeeAlso => {janetMultVar,pommaretMultVar,isPommaretBasis,invReduce,invSyzygies,invResolution}
        }

document {
        Key => {janetMultVar,(janetMultVar,Matrix),(janetMultVar,List)},
        Headline => "return table of multiplicative variables for given module elements as determined by Janet division",
        Usage => "janetMultVar M",
        Inputs => {{ "M, ", ofClass Matrix, " or ", ofClass List }},
        Outputs => {{ "list of HashTable; the i-th hash table specifies which variables of the polynomial ring are multiplicative for the i-th column resp. the i-th element of M; a value of 0 or 1 is assigned to each variable of the polynomial ring; 1 means the variable is multiplicative, 0 indicates a non-multiplicative variable" }},
        EXAMPLE lines ///
          R = QQ[x1,x2,x3]
	  M = matrix {{ x1*x2*x3, x2^2*x3, x1*x2*x3^2 }}
	  janetMultVar M
        ///,
        SeeAlso => {pommaretMultVar,janetBasis,isPommaretBasis}
        }

document {
        Key => {pommaretMultVar,(pommaretMultVar,Matrix),(pommaretMultVar,List)},
        Headline => "return table of multiplicative variables for given module elements as determined by Pommaret division",
        Usage => "pommaretMultVar M",
        Inputs => {{ "M, ", ofClass Matrix, " or ", ofClass List }},
        Outputs => {{ "list of HashTable; the i-th hash table specifies which variables of the polynomial ring are multiplicative for the i-th column resp. the i-th element of M; a value of 0 or 1 is assigned to each variable of the polynomial ring; 1 means the variable is multiplicative, 0 indicates a non-multiplicative variable" }},
        EXAMPLE lines ///
          R = QQ[x1,x2,x3]
	  M = matrix {{ x1*x2*x3, x2^2*x3, x1*x2*x3^2 }}
	  pommaretMultVar M
        ///,
        SeeAlso => {janetMultVar,janetBasis,isPommaretBasis}
        }

document {
        Key => {isPommaretBasis,(isPommaretBasis,InvolutiveBasis)},
        Headline => "check whether or not a given Janet basis is also a Pommaret basis",
        Usage => "isPommaretBasis J",
        Inputs => {{ "J, ", ofClass InvolutiveBasis, ", a Janet basis as returned by ", TO "janetBasis" }},
        Outputs => {{ ofClass Boolean, "; the result equals true if and only if J is a Pommaret basis" }},
        EXAMPLE lines ///
          R = QQ[x,y]
	  I = ideal(x^3,y^2)
	  G = gb I
	  J = janetBasis G
	  isPommaretBasis J
        ///,
        EXAMPLE lines ///
          R = QQ[x,y]
	  I = ideal(x*y,y^2)
	  G = gb I
	  J = janetBasis G
	  isPommaretBasis J
        ///,
        SeeAlso => {janetBasis,basisElements,multVar,janetMultVar,pommaretMultVar}
        }

TEST ///
     -- loadPackage "involutive"
     R = QQ[x,y]
     I = ideal(x^3,y^2)
     G = gb I
     J = janetBasis G
     assert ( isPommaretBasis J == true )
///

TEST ///
     -- loadPackage "involutive"
     R = QQ[x,y]
     I = ideal(x*y,y^2)
     G = gb I
     J = janetBasis G
     assert ( isPommaretBasis J == false )
///

document {
        Key => {invReduce,(invReduce,Matrix,InvolutiveBasis),(invReduce,RingElement,InvolutiveBasis)},
        Headline => "compute normal form modulo Janet basis by involutive reduction",
        Usage => "invReduce(p,J)",
	Inputs => {
	     "p" => Matrix => "the columns are to be reduced modulo J",
	     "J" => InvolutiveBasis => { "a Janet basis as returned by ", TO "janetBasis" }
	     },
        Outputs => {{ "sequence (r,c) of two matrices; the columns of r are the normal forms corresponding to the columns of p; the columns of c contain the reduction coefficients" }},
	Consequences => { "for the output (r,c) we have: the columns of r are in normal form modulo J, and p = r + J#0 * c, where * is matrix multiplication" },
        EXAMPLE lines ///
          R = QQ[x,y,z]
	  M = matrix {{x+y+z, x*y+y*z+z*x, x*y*z-1}};
	  G = gb M
	  J = janetBasis G;
	  p = matrix {{y,y^2,y^3}}
	  invReduce(p,J)
        ///,
        SeeAlso => {janetBasis,invSyzygies}
        }

document {
        Key => {invSyzygies,(invSyzygies,InvolutiveBasis)},
        Headline => "compute Janet basis of syzygies",
        Usage => "invSyzygies J",
        Inputs => {{ "J, ", ofClass InvolutiveBasis, ", a Janet basis as returned by ", TO "janetBasis" }},
        Outputs => {{ ofClass InvolutiveBasis, ", a Janet basis for the syzygies of J" }},
        EXAMPLE lines ///
          R = QQ[x,y,z]
          I = ideal(x,y,z)
          G = gb I
          J = janetBasis G
          invSyzygies J
        ///,
        Caveat => { "cannot be iterated because ", TO "schreyerOrder", " is not used; call ", TO "invResolution", " instead" },
        SeeAlso => {janetBasis,invResolution}
        }

document {
     Key => InvolutiveBasis,
     Headline => "the class of all involutive bases"
     }

document {
        Key => {invResolution,(invResolution,InvolutiveBasis)},
        Headline => "construct a free resolution from a Janet basis",
        Usage => "invResolution J",
        Inputs => {{ "J, ", ofClass InvolutiveBasis, ", a Janet basis as returned by ", TO "janetBasis" }},
        Outputs => {{ "list of InvolutiveBasis such that its i-th entry is a Janet basis for the i-th syzygies" }},
        EXAMPLE lines ///
          R = QQ[x,y,z]
          I = ideal(x,y,z)
          G = gb I
          J = janetBasis G
          invResolution J
        ///,
        SeeAlso => {janetBasis,invSyzygies}
        }

TEST ///
     -- loadPackage "involutive"
     R = QQ[f,e,d,c,b,a]
     M = matrix {{a*b*c, a*b*f, a*c*e, a*d*e, a*d*f, b*c*d, b*d*e, b*e*f, c*d*f, c*e*f}}
     G = gb M
     J = janetBasis G
     isPommaretBasis J
     S = invResolution J
     assert ( length(S) == 4 )
     assert ( zero(S#0#0 * S#1#0) )
     assert ( zero(S#1#0 * S#2#0) )
     assert ( zero(S#2#0 * S#3#0) )
///

TEST ///
     -- loadPackage "involutive"
     R = ZZ/2[f,e,d,c,b,a]
     M = matrix {{a*b*c, a*b*f, a*c*e, a*d*e, a*d*f, b*c*d, b*d*e, b*e*f, c*d*f, c*e*f}}
     G = gb M
     J = janetBasis G
     isPommaretBasis J
     S = invResolution J
     assert ( length(S) == 4 )
     assert ( zero(S#0#0 * S#1#0) )
     assert ( zero(S#1#0 * S#2#0) )
     assert ( zero(S#2#0 * S#3#0) )
///

