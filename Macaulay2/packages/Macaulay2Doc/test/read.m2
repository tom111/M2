-- check for bug involving "read" changing the strings it returns
setRandomSeed()
n = temporaryFileName() | "-randombytes"
n << concatenate apply(10000, i -> random 256) << close
f = openIn n
x = read f;
assert( #x == 4096 )
y = substring(x,1000);
assert( y == substring(x,0,1000) )
x' = read f;
assert( #x' == 4096 )
assert( y == substring(x,0,1000) )			    -- could fail
close f
removeFile n
end
-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/packages/Macaulay2Doc/test read.out"
-- End:
