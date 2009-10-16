-- this is preventing the code in the monomial ideals chapter from working:

S = QQ[x_1..x_5, Weights => {2,3,5,7,11}];
J = ideal(-x_2^3+x_1^2*x_3,x_1^3*x_4-x_2^4,x_1^4*x_5-x_2^5)
K = saturate(J,x_1)					    -- changes in 1.3
assert( K == ideal(x_2^3-x_1^2*x_3,x_1^3*x_4-x_1^2*x_2*x_3,x_1^4*x_5-x_1^2*x_2^2*x_3) )

-- # Local Variables:
-- # compile-command: "make -k -C $M2BUILDDIR/Macaulay2/packages/Macaulay2Doc/test saturate5.out "
-- # End:
