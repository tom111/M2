-- Test of saturation and colon ideals

R = ZZ/101[a..d]/(a^3-a^2*b)
gbTrace=3

saturate(ideal(0_R),0_R,Strategy => Eliminate) == ideal(1_R) -- gives error
saturate(ideal(0_R),0_R,Strategy => Linear) == ideal(1_R) -- gives reasonable error message
saturate(ideal(0_R),0_R,Strategy => Bayer) == ideal(1_R) -- bad error message, gives error though
saturate(ideal(0_R),0_R,Strategy => Iterate) == ideal(1_R) -- this one works!

saturate(ideal(0_R),a_R,Strategy => Eliminate) == ideal(a-b) -- wrong
saturate(ideal(0_R),a_R,Strategy => Linear) == ideal(a-b) -- gives error
saturate(ideal(0_R),a_R,Strategy => Bayer) == ideal(a-b) -- wrong
saturate(ideal(0_R),a_R,Strategy => Iterate) == ideal(a-b) -- this one works!

A = ZZ/101[a..d]/(a^3-a^2*b)
R = A[x,y,z]/(x*a-y^3*a)

saturate(ideal(0_R),0_R,Strategy => Eliminate) == ideal(1_R) -- gives error
saturate(ideal(0_R),0_R,Strategy => Linear) == ideal(1_R) -- gives reasonable error message
saturate(ideal(0_R),0_R,Strategy => Bayer) == ideal(1_R) -- bad error message, gives error though
saturate(ideal(0_R),0_R,Strategy => Iterate) == ideal(1_R) -- this one works!

saturate(ideal(0_R),a_R,Strategy => Eliminate) == ideal(x-y^3,a-b) -- WRONG
saturate(ideal(0_R),a_R,Strategy => Linear) == ideal(x-y^3,a-b) -- BAD error message
saturate(ideal(0_R),a_R,Strategy => Bayer) == ideal(x-y^3,a-b) -- OK
saturate(ideal(0_R),a_R,Strategy => Iterate) == ideal(x-y^3,a_R-b_R) -- FAILS


J = first flattenRing ideal(0_R)

trim promote(saturate(J,lift(a_R, ring J), Strategy => Eliminate), R)


R = QQ[a..d]
I = ideal"a3-b3,abc"
flattenRing I
I === oo_0
