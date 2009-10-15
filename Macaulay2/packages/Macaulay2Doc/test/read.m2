-- check for bug involving "read" changing the strings it returns
setRandomSeed()
n = temporaryFileName()
n << concatenate apply(10000, i -> random 256) << close
f << openIn n
x = read f;
y = x|"";
assert( x == y )
assert( #x == 4096 )
x' = read f;
assert( #x' == 4096 )
assert( x == y )					    -- could fail
close f
removeFile n
