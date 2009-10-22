-- from an email of Dimitri.Markouchevitch@math.univ-lille1.fr
-- sent to MES from DRG 10-16-09
K0=ZZ/67[a];

K1=K0/ideal(a^2+15);

KK=toField K1;

R=KK[x,y,z];

Proj R;

hilbertPolynomial oo
--stdio:6:1:(1):[0]: error: expected a singly graded ring

isHomogeneous ideal(x^4+y^3*z,z^3,y^5)

o7 = false

Proj(R/ideal(x^4+y^3*z,z^3,y^5))
