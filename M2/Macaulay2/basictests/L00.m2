assert = x -> if not x then error "assertion failed "

x = simpleLoad concatenate(srcdir, "L00.input")

assert( x === true )
assert( y === 55 )
