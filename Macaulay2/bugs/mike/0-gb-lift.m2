R = QQ[x,y,z]/(2*x*z-1)
I = ideal y
M = matrix{{x*y}}


S = QQ [u_0, w_0, w_1, x,y, MonomialOrder => {1,2,2}]
I = ideal(2*u_0*y+w_0*y^6-w_1*x^2+w_1*x*y-2*w_1*y^2,2*u_0*x-w_0*y^6+w_1*x^2-w_1*x*y,4*u_0^2-w_0^2*y^10+w_0*w_1*x^2*y^4-w_0*w_1*x*y^5+6*w_0*w_1*y^6-4*w_1^2*x^2+2*w_1^2*x*y-4*w_1^2*y^2)
R = S/I
F = x*y+y^2
use R
M = matrix {{w_1^2*y^4}}
--M % matrix{{F}}
M // matrix{{F}} -- giving the wrong answer!!
matrix{{F}} ** oo - M

--
S = QQ[x,y,t,u,v,w]
I = ideal"xy-tu,2vu-w"
R = S/I
gens gb ideal(x)
gens gb I
matrix{{t*u*v}} // matrix{{x}}
matrix{{x}} * oo

-- Make this a test...
debug Core
R = QQ[a..e]
I = ideal"ab,cd"
J = ideal"abc,cde"
J2 = ideal"a,c"
J3 = ideal"abc,d"
G = gb(I, ChangeMatrix =>true)

(A,B,C) = rawGBMatrixLift(raw G, raw gens J)
assert C
(A,B,C) = rawGBMatrixLift(raw G, raw gens J2)
assert not C
(A,B,C) = rawGBMatrixLift(raw G, raw gens J3)
assert not C




S = QQ [a, b, c, x,y, MonomialOrder => {1,2,2}]
I = ideal"2ay+by6-cx2+cxy-2cy2,
          2ax-by6+cx2-cxy,
	  4a2-b2y10+bcx2y4-bcxy5+6bcy6-4c2x2+2c2xy-4c2y2"
R = S/I
F = matrix"xy+y2"
M = matrix"c2y4"
G = M // F
assert(F * G == M)

G =  gb(F, ChangeMatrix=>true)
getChangeMatrix G

G =  gb(F, ChangeMatrix=>true, Algorithm=>Sugarless)
gbTrace=3
M // F
gens G
