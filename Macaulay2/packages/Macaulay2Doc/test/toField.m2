K0=QQ[a];
K1=K0/ideal(a^2+15);
KK=toField K1;
R=KK[x,y,z];

p = matrix {{x^6}}
debug Core
monomialIdealOfRow := (i,m) -> newMonomialIdeal(ring m,rawMonomialIdeal(raw m, i))
monomialIdealOfRow(0,p)
    -- i13 : monomialIdealOfRow(0,p)
    --                       6
    -- o13 = monomialIdeal (x , -15)	      	   	    -- it's using the equation of the ring, too, somehow
    -- o13 : MonomialIdeal of R
assert( monomialIdealOfRow(0,p) == monomialIdeal x^6 )	    -- this is what breaks the following code

f=(-3+5*a)*x^6+(135+15*a)*x^4*y*z-(45-15*a)*x^2*y^2*z^2-18*x*y^5-18*x*z^5+(15+5*a)*x^3*y^3;
I = ideal f;
assert isHomogeneous I					    -- fails in 1.2, fixed in 1.3
assert( dim I == 2 )					    -- fails in 1.2
assert( dim Proj (R/I) == 1 )				    -- fails in 1.2
assert( hilbertPolynomial I == - 15 * hilbertPolynomial (QQ[x]) + 6 * hilbertPolynomial (QQ[x,y]) ) -- fails in 1.2
