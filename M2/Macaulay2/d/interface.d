--		Copyright 1994-2002 by Daniel R. Grayson

-- this file contains top level routines that call the C++ code in the engine

use C;
use system; 
use util;
use convertr;
use binding;
use nets;
use parser;
use lex;
use gmp;
use engine;
use util;
use tokens;
use err;
use stdiop;
use ctype;
use stdio;
use varstrin;
use strings;
use basic;
use struct;
use objects;

-----------------------------------------------------------------------------
-- types


-----------------------------------------------------------------------------
-- monomials

rawVar(a:Expr):Expr := (
     when a
     is v:Integer do 
     if isInt(v) then toExpr(
	  Ccode(RawMonomialOrNull, 
	       "(engine_RawMonomialOrNull)IM2_Monomial_var(", toInt(v), ",1)" ))
     else WrongArg("a small integer")
     is s:Sequence do 
     if length(s) == 2 then 
     when s.0 is v:Integer do 
     if isInt(v) then 
     when s.1 is e:Integer do 
     if isInt(e) then toExpr(Ccode(RawMonomialOrNull, 
	       "(engine_RawMonomialOrNull)IM2_Monomial_var(",
	       toInt(v), ",", toInt(e), ")" ))
     else WrongArg(2,"a small integer")
     else WrongArg(2,"an integer")
     else WrongArg(1,"a small integer")
     else WrongArg(1,"an integer")
     else WrongArg("an integer or a pair of integers")
     else WrongArg("an integer or a pair of integers")
     );
setupfun("rawVar",rawVar);

rawMonomialExponents(e:Expr):Expr := (
     when e 
     is x:RawMonomial do (
	  y := Ccode(RawArrayInt, "(engine_RawArrayInt)IM2_Monomial_to_arrayint((Monomial*)",x,")" );
	  n := length(y)/2;
	  list(new Sequence len n do (
		    for i from 0 to length(y) by 2 do (
			 provide new Sequence len 2 do (
			      provide Expr(toInteger(y.i));
			      provide Expr(toInteger(y.(i+1))))))))
     else WrongArg("a raw monomial")
     );
setupfun("rawMonomialExponents",rawMonomialExponents);

rawMonomialMake(e:Expr):Expr := (
     -- accepts a list of pairs : {(5,4),(3,7),(2,1)}
     when e
     is l:List do (
	  when isSequenceOfPairsOfSmallIntegers(l.v) is s:string do return(WrongArg(s)) else nothing;
	  when Ccode(RawMonomialOrNull, 
	       "(engine_RawMonomialOrNull)IM2_Monomial_make(",
	          "(M2_arrayint)", getSequenceOfPairsOfSmallIntegers(l.v), 
	       ")" )
	  is x:RawMonomial do Expr(x)
	  is null do buildErrorPacket(EngineError("raw monomial overflow"))
	  )
     else WrongArg("a list of pairs of integers"));
setupfun("rawMonomialMake",rawMonomialMake);

rawMonomialIsOne(e:Expr):Expr := (
     when e is s:Sequence 
     do if length(s) == 2 
     then when s.0 is x:RawMonomial 
     do when s.1 is t:Integer 
     do if t === 1 
     then if Ccode(bool, "IM2_Monomial_is_one((Monomial*)",x,")") then True else False
     else WrongArg(2,"the integer 1")
     else WrongArg(2,"an integer")
     else WrongArg(1,"a raw monomial")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
installMethod(Expr(EqualEqualS), rawMonomialClass,integerClass,
     Expr(CompiledFunction(rawMonomialIsOne,nextHash())));

rawGCD(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2) else
     when s.0 is x:RawMonomial do
     when s.1 is y:RawMonomial do Expr(
	       Ccode(RawMonomial, "IM2_Monomial_gcd((Monomial*)",x,",","(Monomial*)",y,")"))
     else WrongArg(2,"a raw monomial")
     else WrongArg(1,"a raw monomial")
     else WrongArg("a pair of raw monomials")
     );
setupfun("rawGCD",rawGCD);

rawSyz(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2) else
     when s.0 is x:RawMonomial do
     when s.1 is y:RawMonomial do (
	  r := Ccode(RawMonomialPair, 
	       "(engine_RawMonomialPair)IM2_Monomial_syz((Monomial*)",
	       x,",","(Monomial*)",y,
	       ")");
	  Expr(list(Expr(r.a), Expr(r.b))))
     else WrongArg(2,"a raw monomial")
     else WrongArg(1,"a raw monomial")
     else WrongArg("a pair of raw monomials")
     );
setupfun("rawSyz",rawSyz);

monomialQuotient(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is x:RawMonomial do 
     when a.1 is y:RawMonomial do toExpr(quotient(x,y))
     else WrongArg(2,"a raw monomial")
     else WrongArg(1,"a raw monomial")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
installMethod(ColonS,rawMonomialClass,rawMonomialClass,monomialQuotient);

-----------------------------------------------------------------------------
-- monomial orderings

Component := makeProtectedSymbolClosure("Component");
ComponentFun():RawMonomialOrdering := Ccode(RawMonomialOrdering,
     "(engine_RawMonomialOrdering)IM2_MonomialOrdering_component()");

Lex      := makeProtectedSymbolClosure("Lex");
LexSmall := makeProtectedSymbolClosure("LexSmall");
LexTiny  := makeProtectedSymbolClosure("LexTiny");
LexFun     (n:int):RawMonomialOrdering := Ccode(RawMonomialOrdering, "(engine_RawMonomialOrdering)IM2_MonomialOrdering_lex(",n,",1)");
LexSmallFun(n:int):RawMonomialOrdering := Ccode(RawMonomialOrdering, "(engine_RawMonomialOrdering)IM2_MonomialOrdering_lex(",n,",2)");
LexTinyFun (n:int):RawMonomialOrdering := Ccode(RawMonomialOrdering, "(engine_RawMonomialOrdering)IM2_MonomialOrdering_lex(",n,",4)");

RevLex := makeProtectedSymbolClosure("RevLex");
RevLexFun(n:int):RawMonomialOrdering := Ccode(RawMonomialOrdering, "(engine_RawMonomialOrdering)IM2_MonomialOrdering_revlex(",n,")");

GroupLex := makeProtectedSymbolClosure("GroupLex");
GroupLexFun(n:int):RawMonomialOrdering := Ccode(RawMonomialOrdering, "(engine_RawMonomialOrdering)IM2_MonomialOrdering_laurent(",n,")");

NCLex := makeProtectedSymbolClosure("NCLex");
NCLexFun(n:int):RawMonomialOrdering := Ccode(RawMonomialOrdering, "(engine_RawMonomialOrdering)IM2_MonomialOrdering_NClex(",n,")");

GRevLex := makeProtectedSymbolClosure("GRevLex");
GRevLexSmall := makeProtectedSymbolClosure("GRevLexSmall");
GRevLexTiny := makeProtectedSymbolClosure("GRevLexTiny");
GRevLexFun(n:array(int)):RawMonomialOrdering := Ccode(RawMonomialOrdering,
     "(engine_RawMonomialOrdering)IM2_MonomialOrdering_grevlex((M2_arrayint)",n,",1)");
GRevLexSmallFun(n:array(int)):RawMonomialOrdering := Ccode(RawMonomialOrdering,
     "(engine_RawMonomialOrdering)IM2_MonomialOrdering_grevlex((M2_arrayint)",n,",2)");
GRevLexTinyFun(n:array(int)):RawMonomialOrdering := Ccode(RawMonomialOrdering,
     "(engine_RawMonomialOrdering)IM2_MonomialOrdering_grevlex((M2_arrayint)",n,",4)");

Weights := makeProtectedSymbolClosure("Weights");
WeightsFun(n:array(int)):RawMonomialOrdering := Ccode(RawMonomialOrdering,
     "(engine_RawMonomialOrdering)IM2_MonomialOrdering_weights((M2_arrayint)",n,")");

join(s:RawMonomialOrderingArray):RawMonomialOrdering := (
     Ccode(RawMonomialOrdering,
     	  "(engine_RawMonomialOrdering)IM2_MonomialOrdering_join((MonomialOrdering_array)",s,")")
     );

arrayint := array(int);
funtype := fun1 or fun2 or fun3;
funtypeornull := fun1 or fun2 or fun3 or null;
fun1 := function():RawMonomialOrdering;
fun2 := function(int):RawMonomialOrdering;
fun3 := function(arrayint):RawMonomialOrdering;;

Maker := { sym:SymbolClosure, fun:funtype };

makers := array(Maker)(
     Maker(Component,ComponentFun),
     Maker(Lex,LexFun),
     Maker(LexSmall,LexSmallFun),
     Maker(LexTiny,LexTinyFun),
     Maker(RevLex,RevLexFun),
     Maker(GroupLex,GroupLexFun),
     Maker(NCLex,NCLexFun),
     Maker(GRevLex,GRevLexFun),
     Maker(GRevLexSmall,GRevLexSmallFun),
     Maker(GRevLexTiny,GRevLexTinyFun),
     Maker(Weights,WeightsFun)
     );

getmaker(sym:SymbolClosure):funtypeornull := (
     foreach pair in makers do if sym == pair.sym then (
	  when pair.fun
	  is f:fun1 do return(f)
	  is f:fun2 do return(f)
	  is f:fun3 do return(f)
	  );
     null());

trivialMonomial := Ccode(RawMonomial, 
     "(engine_RawMonomial)IM2_Monomial_make(", "(M2_arrayint)", array(int)(), ")" 
     );

rawMonomialOrdering(e:Expr):Expr := (
     -- This routine gets an expression like this:
     -- { GRevLexSmall => {1,2,3}, Component, LexTiny => 4, Lex => 5, Weights => {1,2,3} }
     -- For GRevLex, the weights are already provided by top level code.
     -- Each member of the sequence results in one monomial ordering, and they sequence
     -- is then "joined".
     -- The weights for grevlex have to be > 0.
     -- Limit the total number of variables to 2^15-1.
     when e is s:List do (
	  -- first check it
	  foreach spec in s.v do (
	       when spec is sp:List do
	       if sp.class == optionClass && length(sp.v)==2 then 
	       when sp.v.0 
	       is sym:SymbolClosure do (
		    when getmaker(sym)
		    is g:fun1 do (
			 if sp.v.1 != nullE
			 then return(buildErrorPacket("expected option value to be 'null'"));
			 )
		    is g:fun2 do (
			 if !isSmallInt(sp.v.1)
			 then return(buildErrorPacket("expected option value to be a small integer"));
			 )
		    is g:fun3 do (
			 if !isListOfSmallIntegers(sp.v.1) then return(
			      buildErrorPacket("expected option value to be list of small integers"));
			 )
		    is null do return(buildErrorPacket("expected option key to be a monomial ordering key"))
		    )
	       else return(buildErrorPacket("expected option key to be a symbol"))
	       else return(WrongArg("a list of options"))
	       else return(WrongArg("a list of options")));
	  -- then accumulate it
     	  Expr(join(new RawMonomialOrderingArray len length(s.v) do (
	       foreach spec in s.v do
	       when spec is sp:List do
	       when sp.v.0 is sym:SymbolClosure do (
		    when getmaker(sym)
		    is g:fun1 do provide g()
		    is g:fun2 do provide g(getSmallInt(sp.v.1))
		    is g:fun3 do provide g(getListOfSmallIntegers(sp.v.1))
		    is null do nothing
		    )
	       else nothing
	       else nothing;
	       provide ComponentFun();		    -- just in case, to prevent a loop
	       ))))
     else WrongArg("a list of options"));
setupfun("rawMonomialOrdering",rawMonomialOrdering);

rawMonomialOrderingProduct(e:Expr):Expr := (
     when e
     is m:RawMonomialOrdering do e
     is s:Sequence do 
     if !isSequenceOfMonomialOrderings(s) 
     then WrongArg("a sequence of raw monomial orderings") 
     else Expr(Ccode(
	       RawMonomialOrdering, 
	       "(engine_RawMonomialOrdering)IM2_MonomialOrdering_product(",
	       "(MonomialOrdering_array)", getSequenceOfMonomialOrderings(s),
	       ")"
	       ))
     else WrongArg("a sequence of raw monomial orderings"));
setupfun("rawMonomialOrderingProduct",rawMonomialOrderingProduct);

-----------------------------------------------------------------------------
-- monoids

rawMonoid(mo:RawMonomialOrdering,names:array(string),degreesMonoid:RawMonoid,degs:array(int)):Expr := (
     when Ccode(RawMonoidOrNull, 
	  "(engine_RawMonoidOrNull)IM2_Monoid_make(",
	      "(MonomialOrdering *)", mo, ",",
	      "(M2_stringarray)", names, ",",
	      "(Monoid *)", degreesMonoid, ",",
	      "(M2_arrayint)", degs,
	  ")")
     is m:RawMonoid do Expr(m)
     is null do buildErrorPacket(EngineError("internal error: unexplained failure to make raw monoid"))
     );
rawMonoid(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) == 0 then Expr(Ccode(RawMonoid,"(engine_RawMonoid)IM2_Monoid_trivial()"))
     else if length(s) == 4 then 
     when s.0 is mo:RawMonomialOrdering do
     if isListOfStrings(s.1) then (
	  names := getListOfStrings(s.1);
	  when s.2 is degreesMonoid:RawMonoid do
	  if isListOfSmallIntegers(s.3) then (
	       degs := getListOfSmallIntegers(s.3);
	       rawMonoid(mo,names,degreesMonoid,degs))
	  else WrongArg(4,"a list of small integers (flattened list of degrees)")
	  else WrongArg(3,"the degrees monoid"))
     else WrongArg(2,"a list of strings to be used as names")
     else WrongArg(1,"a monomial ordering")
     else buildErrorPacket("expected 0 or 4 arguments")
     else buildErrorPacket("expected 0 or 4 arguments")
     );
setupfun("rawMonoid",rawMonoid);

-----------------------------------------------------------------------------
-- rings

rawZZ(e:Expr):Expr := (
     when e is s:Sequence do if length(s) == 0
     then Expr(Ccode(RawRing,"(engine_RawRing)IM2_Ring_ZZ()"))
     else WrongNumArgs(0)
     else WrongNumArgs(0)
     );
setupfun("rawZZ", rawZZ);

rawZZp(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is p:Integer do 
     if !isInt(p) then WrongArg(1,"a small integer") else
     when a.1 is M:RawMonoid do toExpr(Ccode(RawRingOrNull,
	       "(engine_RawRingOrNull)IM2_Ring_ZZp(",
	       toInt(p), ",",
	       "(Monoid *)", M,
	       ")"
	       ))
     else WrongArg(2,"a raw (degree) monoid")
     else WrongArg(1,"an integer")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
setupfun("rawZZp", rawZZp);

rawPolynomialRing(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is K:RawRing do 
     when a.1 is M:RawMonoid do toExpr(Ccode(RawRingOrNull,
	       "(engine_RawRingOrNull)IM2_Ring_polyring(",
	       "(Ring *)", K, ",",
	       "(Monoid *)", M,
	       ")"
	       ))
     else WrongArg(2,"a raw monoid")
     else WrongArg(1,"a raw ring")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
setupfun("rawPolynomialRing",rawPolynomialRing);

rawSkewPolynomialRing(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 3 then 
     when a.0 is K:RawRing do 
     when a.1 is M:RawMonoid do 
     if !isListOfSmallIntegers(a.2) then WrongArg(3,"a list of small integers")
     else NotYet("skew polynomial rings")
-- 	  toExpr(Ccode(RawRingOrNull,
-- 	       "(engine_RawRingOrNull)IM2_Ring_skew_polyring(",
-- 	       "(Ring *)", K, ",",
-- 	       "(Monoid *)", M, ",",
-- 	       "(M2_arrayint)", getListOfSmallIntegers(a.2), -- skew variables
-- 	       ")"
-- 	       ))
     else WrongArg(2,"a raw monoid")
     else WrongArg(1,"a raw ring")
     else WrongNumArgs(3)
     else WrongNumArgs(3));
setupfun("rawSkewPolynomialRing",rawSkewPolynomialRing);

rawWeylAlgebra(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 5 then 
     when a.0 is K:RawRing do 
     when a.1 is M:RawMonoid do 
     if !isListOfSmallIntegers(a.2) then WrongArg(3,"a list of small integers") else
     if !isListOfSmallIntegers(a.3) then WrongArg(4,"a list of small integers") else
     if !isSmallInt(a.4) then WrongArg(5,"a small integer") else
     toExpr(Ccode(RawRingOrNull,
	       "(engine_RawRingOrNull)IM2_Ring_weyl_algebra(",
	       "(Ring *)", K, ",",
	       "(Monoid *)", M, ",",
	       "(M2_arrayint)", getListOfSmallIntegers(a.2), ",",  -- commvars
	       "(M2_arrayint)", getListOfSmallIntegers(a.3), ",", -- diff vars
	       getSmallInt(a.4), -- homog var
	       ")"
	       ))
     else WrongArg(2,"a raw monoid")
     else WrongArg(1,"a raw ring")
     else WrongNumArgs(5)
     else WrongNumArgs(5));
setupfun("rawWeylAlgebra",rawWeylAlgebra);

rawFractionRing(e:Expr):Expr := (
     when e is R:RawRing do Expr(
	  Ccode(RawRing,"(engine_RawRing)IM2_Ring_frac(",
	       "(Ring *)", R,
	       ")"))
     else WrongArg("a raw ring")
     );
setupfun("rawFractionRing", rawFractionRing);

rawSchurRing(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is K:RawRing do 
     when a.1 is M:RawMonoid do toExpr(Ccode(RawRingOrNull,
	       "(engine_RawRingOrNull)IM2_Ring_schur(",
	       "(Ring *)", K, ",",
	       "(Monoid *)", M,
	       ")"
	       ))
     else WrongArg(2,"a raw monoid")
     else WrongArg(1,"a raw ring")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
setupfun("rawSchurRing",rawSchurRing);

-----------------------------------------------------------------------------
-- ring elements

rawRingVar(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) != 3 then WrongNumArgs(3) else
     when a.0 is R:RawRing do
     when a.1 is v:Integer do
     if !isInt(v) then WrongArg(2,"a small integer") else
     when a.2 is e:Integer do
     if !isInt(e) then WrongArg(3,"a small integer") else
     toExpr(Ccode(RawRingElementOrNull,
	       "(engine_RawRingElementOrNull)IM2_RingElement_make_var(",
	       "(Ring *)", R, ",",
	       toInt(v), ",",
	       toInt(e),
	       ")"
	       ))
     else WrongArg(3,"an integer")
     else WrongArg(2,"an integer")
     else WrongArg(1,"a raw ring")
     else WrongNumArgs(3));
setupfun("rawRingVar",rawRingVar);

rawFromNumber(e:Expr):Expr := (
     when e is s:Sequence do if length(s) == 2 then
     when s.0
     is R:RawRing do
     when s.1
     is n:Integer do Expr(Ccode(
	       RawRingElement, "IM2_RingElement_from_Integer(",
	       "(Ring*)",R,",",
	       "(M2_Integer)",n,
	       ")"))
     is x:Real do (
	  when Ccode(RawRingElementOrNull, "IM2_RingElement_from_double((Ring*)",R,",",x.v,")")
	  is r:RawRingElement do Expr(r)
	  is null do buildErrorPacket(EngineError("promoting real number to ring element: not implemented yet")))
     is x:BigReal do (
	  -- when Ccode(RawRingElementOrNull, "IM2_RingElement_from_BigReal((Ring*)",R,",(M2_BigReal)",x,")")
	  -- is r:RawRingElement do Expr(r)
	  -- is null do
	  buildErrorPacket(EngineError("can't promote big real number to ring element")))
     else WrongArg(2,"an integer or real number")
     else WrongArg(1,"a raw ring")
     else WrongNumArgs(2)
     else WrongNumArgs(2)
     );
setupfun("rawFromNumber", rawFromNumber);

rawMultiDegree(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr(
	  Ccode(RawArrayIntOrNull, "(engine_RawArrayIntOrNull)IM2_RingElement_multidegree(",
	       "(RingElement*)",x, ")" ) )
     is x:RawVector do toExpr(
	  Ccode(RawArrayIntOrNull, "(engine_RawArrayIntOrNull)IM2_Vector_multidegree(",
	       "(Vector*)",x, ")" ) )
     is x:RawFreeModule do toExpr(
	  Ccode(RawArrayIntOrNull, "(engine_RawArrayIntOrNull)IM2_FreeModule_get_degrees(",
	       "(FreeModule*)",x, ")" ) )
     is x:RawMatrix do toExpr(
	  Ccode(RawArrayIntOrNull, "(engine_RawArrayIntOrNull)IM2_Matrix_get_degree(",
	       "(Matrix*)",x, ")" ) )
     else WrongArg("a raw ring element or vector")
     );
setupfun("rawMultiDegree",rawMultiDegree);

rawDegree(e:Expr):Expr := (
     when e
     is x:RawMonomial do Expr(toInteger(Ccode(int, "IM2_Monomial_degree((Monomial*)",x,")")))
     is s:Sequence do 
     if length(s) != 2 then buildErrorPacket("expected 1 or 2 arguments") else
     when s.0 is x:RawRingElement do 
     if !isListOfSmallIntegers(s.1) then WrongArg(2,"a list of small integers") else
     toExpr(
	  Ccode( IntegerPairOrNull, "(engine_IntegerPairOrNull)IM2_RingElement_degree(",
	       "(RingElement*)",x, ",",
	       "(M2_arrayint)", getListOfSmallIntegers(s.1),
	       ")"
	       ))
     else WrongArg(1,"a raw ring element")
     else WrongArg("a raw monomial or a pair: raw ring element, list of weights")
     );
setupfun("rawDegree",rawDegree);

rawTermCount(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr( Ccode( int, "IM2_RingElement_n_terms(", "(RingElement*)",x, ")" ))
     is x:RawVector do toExpr( Ccode( int, "IM2_Vector_n_terms(", "(Vector*)",x, ")" ))
     else WrongArg("a raw ring element or vector")
     );
setupfun("rawTermCount",rawTermCount);

rawIsHomogeneous(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr( Ccode( bool, "IM2_RingElement_is_graded(", "(RingElement*)",x, ")" ))
     is x:RawVector do toExpr( Ccode( bool, "IM2_Vector_is_graded(", "(Vector*)",x, ")" ))
     is x:RawMatrix do toExpr( Ccode( bool, "IM2_Matrix_is_graded(", "(Matrix*)",x, ")" ))
     else WrongArg("a raw ring element or vector")
     );
setupfun("rawIsHomogeneous",rawIsHomogeneous);

rawIsZero(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr( Ccode( bool, "IM2_RingElement_is_zero(", "(RingElement*)",x, ")" ))
     is x:RawVector do toExpr( Ccode( bool, "IM2_Vector_is_zero(", "(Vector*)",x, ")" ))
     is x:RawMatrix do toExpr( Ccode( bool, "IM2_Matrix_is_zero(", "(Matrix*)",x, ")" ))
     else WrongArg("a raw ring element or vector")
     );
setupfun("rawIsZero",rawIsZero);

rawToInteger(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr( 
	  Ccode( IntegerOrNull, "(engine_IntegerOrNull)IM2_RingElement_to_Integer(", "(RingElement*)",x, ")" ))
     else WrongArg("a raw ring element")
     );
setupfun("rawToInteger",rawToInteger);

rawLeadCoefficient(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr( 
	  Ccode( RawRingElementOrNull, 
	       "(engine_RawRingElementOrNull)IM2_RingElement_lead_coeff(",
	       "(RingElement*)",x, 
	       ")" ))
     else WrongArg("a raw ring element")
     );
setupfun("rawLeadCoefficient",rawLeadCoefficient);

rawLeadMonomial(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr( 
	  Ccode( RawMonomialOrNull, 
	       "(engine_RawMonomialOrNull)IM2_RingElement_lead_monomial(",
	       "(RingElement*)",x, 
	       ")" ))
     else WrongArg("a raw ring element")
     );
setupfun("rawLeadMonomial",rawLeadMonomial);

-- rawToPairs(e:Expr):Expr := (
--      when e
--      is x:RawRingElement do toExpr( 
-- 	  Ccode( RawArrayPairOrNull, "(engine_RawArrayPairOrNull)IM2_RingElement_list_form(",
-- 	       "(RingElement*)",x, 
-- 	       ")" ))
--      else WrongArg("a raw ring element")
--      );
-- setupfun("rawToPairs",rawToPairs);

ringElementMod(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is x:RawRingElement do 
     when a.1 is y:RawRingElement do toExpr(x % y)
     else WrongArg(2,"a raw ring element")
     else WrongArg(1,"a raw ring element")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
installMethod(PercentS,rawRingElementClass,rawRingElementClass,ringElementMod);

rawDivMod(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is x:RawRingElement do 
     when a.1 is y:RawRingElement do toExpr(
	  Ccode(RawRingElementPairOrNull,
	       "(engine_RawRingElementPairOrNull)",
	       "IM2_RingElement_divmod(",
	       "(RingElement *)", x, ",",
	       "(RingElement *)", y,
	       ")"
	       )
	  )
     else WrongArg(2,"a raw ring element")
     else WrongArg(1,"a raw ring element")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
setupfun("rawDivMod",rawDivMod);

rawPromote(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is R:RawRing do 
     when a.1 is x:RawRingElement do toExpr(
	  Ccode(RawRingElementOrNull, 
		    "(engine_RawRingElementOrNull)IM2_RingElement_promote(",
		    "(Ring *)", R,
		    ",(RingElement *)", x,
		    ")" ))
     else WrongArg(2,"a raw ring element")
     else WrongArg(1,"a raw ring")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
setupfun("rawPromote", rawPromote);

rawLift(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is R:RawRing do 
     when a.1 is x:RawRingElement do toExpr(
	  Ccode(RawRingElementOrNull, 
		    "(engine_RawRingElementOrNull)IM2_RingElement_lift(",
		    "(Ring *)", R,
		    ",(RingElement *)", x,
		    ")" ))
     else WrongArg(2,"a raw ring element")
     else WrongArg(1,"a raw ring")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
setupfun("rawLift", rawLift);

rawRing(e:Expr):Expr := (
     when e
     is x:RawRingElement do Expr(
	  Ccode(RawRing, "IM2_RingElement_ring(", "(RingElement *)",x, ")" ))
     is x:RawFreeModule do Expr(
	  Ccode(RawRing, "IM2_FreeModule_ring(", "(FreeModule *)",x, ")" ))
     else WrongArg("a raw ring element or free module")
     );
setupfun("rawRing", rawRing);

rawHomogenize(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) == 3 then (
	  when s.0
	  is a:RawRingElement do (
	       if !isSmallInt(s.1) then WrongArg(2,"a small integer") else
	       if !isListOfSmallIntegers(s.2) then WrongArg(3,"a list of small integers") else
	       toExpr(Ccode(RawRingElementOrNull,
			 "(engine_RawRingElementOrNull)IM2_RingElement_homogenize(",
			 "(RingElement *)", a, ",",
			 getSmallInt(s.1), ",",		    -- var number v
			 "(M2_arrayint)", getListOfSmallIntegers(s.2), -- weights
			 ")"
			 )
		    )
	       )
	  is a:RawVector do (
	       if !isSmallInt(s.1) then WrongArg(2,"a small integer") else
	       if !isListOfSmallIntegers(s.2) then WrongArg(3,"a list of small integers") else
	       toExpr(Ccode(RawVectorOrNull,
			 "(engine_RawVectorOrNull)IM2_Vector_homogenize(",
			 "(Vector *)", a, ",",
			 getSmallInt(s.1), ",",		    -- var number v
			 "(M2_arrayint)", getListOfSmallIntegers(s.2), -- weights
			 ")"
			 )
		    )
	       )
	  else WrongArg(1,"a raw ring element or vector")
	  )
     else if length(s) == 4 then (
	  when s.0
	  is a:RawRingElement do (
	       if !isSmallInt(s.1) then WrongArg(2,"a small integer") else
	       if !isSmallInt(s.2) then WrongArg(3,"a small integer") else
	       if !isListOfSmallIntegers(s.3) then WrongArg(4,"a list of small integers") else
	       toExpr(Ccode(RawRingElementOrNull,
			 "(engine_RawRingElementOrNull)IM2_RingElement_homogenize_to_degree(",
			 "(RingElement *)", a, ",",
			 getSmallInt(s.1), ",",		    -- var number v
			 getSmallInt(s.2), ",",		    -- target degree
			 "(M2_arrayint)", getListOfSmallIntegers(s.3), -- weights
			 ")"
			 )
		    )
	       )
	  is a:RawVector do (
	       if !isSmallInt(s.1) then WrongArg(2,"a small integer") else
	       if !isSmallInt(s.2) then WrongArg(3,"a small integer") else
	       if !isListOfSmallIntegers(s.3) then WrongArg(4,"a list of small integers") else
	       toExpr(Ccode(RawVectorOrNull,
			 "(engine_RawVectorOrNull)IM2_Vector_homogenize_to_degree(",
			 "(Vector *)", a, ",",
			 getSmallInt(s.1), ",",		    -- var number v
			 getSmallInt(s.2), ",",		    -- target degree
			 "(M2_arrayint)", getListOfSmallIntegers(s.3), -- weights
			 ")"
			 )
		    )
	       )
	  else WrongArg(1,"a raw ring element or vector")
	  )
     else buildErrorPacket("expected 3 or 4 arguments")
     else buildErrorPacket("expected 3 or 4 arguments"));
setupfun("rawHomogenize",rawHomogenize);

rawTerm(e:Expr):Expr := (
     when e is s:Sequence do 
     if length(s) == 3 then 
     when s.0 is R:RawRing do 
     when s.1 is a:RawRingElement do
     when s.2 is m:RawMonomial do toExpr(Ccode(RawRingElementOrNull,
	       "(engine_RawRingElementOrNull)IM2_RingElement_term(",
	       "(Ring *)", R, ",", "(RingElement *)", a, ",", "(Monomial *)", m, ")" ))
     else WrongArg(3,"a raw monomial")
     else WrongArg(2,"a raw ring element")
     else when s.0 is F:RawFreeModule do 
     when s.1 is a:RawRingElement do
     when s.2 is n:Integer do
     if isInt(n) then toExpr(Ccode(RawVectorOrNull,
	       "(engine_RawVectorOrNull)IM2_Vector_term(",
	       "(FreeModule *)", F, ",", "(RingElement *)", a, ",", toInt(n), ")" ))
     else WrongArg(3,"a small integer")
     else WrongArg(3,"an integer")
     else WrongArg(2,"a raw ring element")
     else WrongArg(1,"a raw ring or a raw free module")
     else WrongNumArgs(3)
     else WrongNumArgs(3));
setupfun("rawTerm",rawTerm);

rawGetTerms(e:Expr):Expr := (
     when e is s:Sequence do 
     if length(s) == 3 then 
     when s.0 is f:RawRingElement do 
     when s.1 is lo:Integer do
     if !isInt(lo) then WrongArg(2,"a small integer") else
     when s.2 is hi:Integer do
     if !isInt(hi) then WrongArg(3,"a small integer") else
     toExpr(Ccode(RawRingElementOrNull,
	       "(engine_RawRingElementOrNull)IM2_RingElement_get_terms(",
	       "(RingElement *)", f, ",", toInt(lo), ",", toInt(hi), ")" ))
     else WrongArg(3,"an integer")
     else WrongArg(2,"an integer")
     else WrongArg(1,"a raw ring element")
     else WrongNumArgs(3)
     else WrongNumArgs(3));
setupfun("rawGetTerms",rawGetTerms);

rawCoefficient(e:Expr):Expr := (
     when e is a:Sequence do 
     if length(a) == 2 then 
     when a.0 is x:RawRingElement do 
     when a.1 is m:RawMonomial do toExpr(
	  Ccode(RawRingElementOrNull,"(engine_RawRingElementOrNull)",
	       "IM2_RingElement_get_coeff(",
	       "(RingElement *)", x, ",",
	       "(Monomial *)", m,
	       ")"))
     else WrongArg(2,"a raw monomial")
     else WrongArg(1,"a raw ring element")
     else WrongNumArgs(2)
     else WrongNumArgs(2));
setupfun("rawCoefficient",rawCoefficient);

rawNumerator(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr( 
	  Ccode( RawRingElementOrNull, 
	       "(engine_RawRingElementOrNull)IM2_RingElement_numerator(",
	       "(RingElement*)",x, ")" ))
     else WrongArg("a raw ring element"));
setupfun("rawNumerator",rawNumerator);

rawDenominator(e:Expr):Expr := (
     when e
     is x:RawRingElement do toExpr( 
	  Ccode( RawRingElementOrNull, 
	       "(engine_RawRingElementOrNull)IM2_RingElement_denominator(",
	       "(RingElement*)",x, ")" ))
     else WrongArg("a raw ring element")
     );
setupfun("rawDenominator",rawDenominator);

rawFraction(e:Expr):Expr := (
     when e is s:Sequence do 
     if length(s) == 3 then 
     when s.0 is F:RawRing do 
     when s.1 is x:RawRingElement do
     when s.2 is y:RawRingElement do toExpr(Ccode(RawRingElementOrNull,
	       "(engine_RawRingElementOrNull)IM2_RingElement_fraction(",
	       "(Ring *)", F, ",", "(RingElement *)", x, ",", "(RingElement *)", y, ")" ))
     else WrongArg(3,"x raw ring element")
     else WrongArg(2,"x raw ring element")
     else WrongArg(1,"x raw fraction ring")
     else WrongNumArgs(3)
     else WrongNumArgs(3));
setupfun("rawFraction",rawFraction);

-----------------------------------------------------------------------------
-- free modules

rawRank(e:Expr):Expr := (
     when e
     is x:RawFreeModule do toExpr( Ccode( int, "IM2_FreeModule_rank(", "(FreeModule*)",x, ")" ))
     else WrongArg("a raw free module")
     );
setupfun("rawRank",rawRank);

rawFreeModule(e:Expr):Expr := (
     when e
     -- make_schreyer here
     is v:RawVector do (
	  Expr(Ccode(RawFreeModule, "(engine_RawFreeModule)",
		    "IM2_Vector_freemodule(",
		    "(Vector *)", v,
		    ")"
		    )
	       )
	  )
     is s:Sequence do
     if length(s) == 2 then (
	  when s.0
	  is R:RawRing do (
	       when s.1
	       is rank:Integer do (
		    if isInt(rank)
		    then toExpr( Ccode( RawFreeModuleOrNull, 
			      "(engine_RawFreeModuleOrNull)IM2_FreeModule_make(",
			      "(Ring*)",R, ",", toInt(rank), ")" ))
		    else WrongArg(2,"a small integer or a sequence of small integers"))
	       is degs:Sequence do (
		    if isSequenceOfSmallIntegers(degs)
		    then toExpr( Ccode( RawFreeModuleOrNull, 
			      "(engine_RawFreeModuleOrNull)IM2_FreeModule_make_degs(",
			      "(Ring*)", R, ",", 
			      "(M2_arrayint)", getSequenceOfSmallIntegers(degs),
			      ")" ))
		    else WrongArg(2,"a small integer or a sequence of small integers"))
	       else WrongArg(2,"a small integer or a sequence of small integers"))
	  else WrongArg(1,"a raw ring"))
     else buildErrorPacket("expected 2 arguments")
     else buildErrorPacket("expected a raw vector or 2 arguments"));
setupfun("rawFreeModule",rawFreeModule);

rawZero(e:Expr):Expr := (
     when e
     is F:RawFreeModule do Expr( Ccode( RawVector, 
	       "(engine_RawVector)IM2_Vector_zero(",
	       "(FreeModule*)",F,
	       ")" ))
     else WrongArg("a raw free module")
     );
setupfun("rawZero",rawZero);

rawExteriorPower(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0 is n:Integer do
     if !isInt(n) then WrongArg(1,"a small integer") else
     when s.1
     is F:RawFreeModule do Expr(Ccode(RawFreeModule, "(engine_RawFreeModule)",
	       "IM2_FreeModule_exterior(",
	       toInt(n), ",",
	       "(FreeModule *)", F,
	       ")" ))
     is M:RawMatrix do NotYet("exterior power of raw matrices")
     else WrongArg(2,"a raw free module")
     else WrongArg(1,"an integer")
     else WrongNumArgs(2));
setupfun("rawExteriorPower",rawExteriorPower);

rawSymmetricPower(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0 is n:Integer do
     if !isInt(n) then WrongArg(1,"a small integer") else
     when s.1
     is F:RawFreeModule do Expr(Ccode(RawFreeModule, "(engine_RawFreeModule)",
	       "IM2_FreeModule_symm(",
	       toInt(n), ",",
	       "(FreeModule *)", F,
	       ")" ))
     is M:RawMatrix do NotYet("symmetric power of raw matrices")
     else WrongArg(2,"a raw free module")
     else WrongArg(1,"an integer")
     else WrongNumArgs(2));
setupfun("rawSymmetricPower",rawSymmetricPower);

rawDual(e:Expr):Expr := (
     when e
     is F:RawFreeModule do Expr(Ccode(RawFreeModule, "(engine_RawFreeModule)",
	       "IM2_FreeModule_dual(", "(FreeModule *)", F, ")" ))
     is M:RawMatrix do Expr(Ccode(RawMatrix, "(engine_RawMatrix)",
	       "IM2_Matrix_transpose(", "(Matrix *)", M, ")" ))
     else WrongArg("a raw free module or matrix"));
setupfun("rawDual",rawDual);
-----------------------------------------------------------------------------
-- vectors

rawVector(e:Expr):Expr := (
     when e
     is s:Sequence do (
	  when s.0
     	  is F:RawFreeModule do (
	       if isSequenceOfRingElements(s.1) then (
		    toExpr(Ccode(RawVectorOrNull,
			      "(engine_RawVectorOrNull)IM2_Vector_make(",
			      "(FreeModule*)", F, ",",
			      "(RingElement_array *)", getSequenceOfRingElements(s.1),
			      ")"
			      )
			 )
		    )
	       else WrongArg(2,"a sequence of ring elements")
	       )
	  else WrongArg(1,"a raw free module")
	  )
     else WrongNumArgs(2)
     );
setupfun("rawVector",rawVector);

rawVectorEntries(e:Expr):Expr := (
     when e is v:RawVector do (
	  toExpr(Ccode(RawRingElementArray, 
		    "(engine_RawRingElementArray)",
		    "IM2_Vector_to_ringelements(",
		    "(Vector *)", v,
		    ")"
		    )
	       )
	  )
     else WrongArg("a raw vector")
     );
setupfun("rawVectorEntries",rawVectorEntries);

rawVectorEntry(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0 is v:RawVector do (
	  when s.1 is i:Integer do (
	       if isInt(i) then toExpr(Ccode(RawRingElementOrNull, 
			 "(engine_RawRingElementOrNull)",
			 "IM2_Vector_component(",
			 "(Vector *)", v, ",",
			 toInt(i),
			 ")"
			 )
		    )
	       else WrongArg(2,"a small integer")
	       )
	  else WrongArg(2,"an integer")
	  )
     else WrongArg("a raw vector")
     else WrongNumArgs(2)
     );
setupfun("rawVectorEntry",rawVectorEntry);

-----------------------------------------------------------------------------
-- matrices


rawSource(e:Expr):Expr := (
     when e
     is M:RawMatrix do Expr( Ccode( RawFreeModule, "IM2_Matrix_get_source(", "(Matrix*)",M, ")" ))
     else WrongArg("a raw matrix")
     );
setupfun("rawSource",rawSource);
rawTarget(e:Expr):Expr := (
     when e
     is M:RawMatrix do Expr( Ccode( RawFreeModule, "IM2_Matrix_get_target(", "(Matrix*)",M, ")" ))
     else WrongArg("a raw matrix")
     );
setupfun("rawTarget",rawTarget);

rawMatrix(e:Expr):Expr := (
     when e
     is I:RawMonomialIdeal do (
	  Expr(Ccode(RawMatrix, "(engine_RawMatrix)",
		    "IM2_MonomialIdeal_to_matrix(", 
		    "(MonomialIdeal *)", I, ")"
		    )))
     is s:Sequence do (
	  if length(s) == 2 then (
	       when s.0 is target:RawFreeModule do (
		    if isSequenceOfVectors(s.1) then (
			 toExpr(Ccode( RawMatrixOrNull, 
	       			   "(engine_RawMatrixOrNull)IM2_Matrix_make1(",
	       			   "(FreeModule*)",target,",",
				   "(Vector_array*)", getSequenceOfVectors(s.1),
	       			   ")" )
			      )
			 )
		    else WrongArg(2,"a sequence of raw vectors")
		    )
	       else WrongArg(1,"a raw free module")
	       )
	  else if length(s) == 4 then (
	       when s.0 is target:RawFreeModule do (
		    when s.1 is source:RawFreeModule do (
			 if isSequenceOfSmallIntegers(s.2) then (
			      when s.3 is M:RawMatrix do (
				   toExpr(Ccode( RawMatrixOrNull, 
					     "(engine_RawMatrixOrNull)IM2_Matrix_make3(",
					     "(FreeModule*)",target,",",
					     "(FreeModule*)",source,",",
					     "(M2_arrayint)",getSequenceOfSmallIntegers(s.2),",",
					     "(Matrix*)",M,
					     ")" 
					     )
					)
				   )
			      else if isSequenceOfVectors(s.3) then (
				   toExpr(Ccode( RawMatrixOrNull, 
					     "(engine_RawMatrixOrNull)IM2_Matrix_make2(",
					     "(FreeModule*)",target,",",
					     "(FreeModule*)",source,",",
					     "(M2_arrayint)",getSequenceOfSmallIntegers(s.2),",",
					     "(Vector_array*)",getSequenceOfVectors(s.3),
					     ")" 
					     )
					)
				   )
			      else WrongArg(4,"a raw matrix or a sequence of raw vectors")
			      )
			 else WrongArg(3,"a sequence of small integers")
			 )
		    else WrongArg(2,"a raw free module")
		    )
	       else WrongArg(1,"a raw free module")
	       )
	  else buildErrorPacket("expected 2 or 4 arguments")
	  )
     else buildErrorPacket("expected a raw monomial ideal or 2 or 4 arguments")
     );
setupfun("rawMatrix",rawMatrix);

rawConcat(e:Expr):Expr := (
     if isSequenceOfMatrices(e) then
     toExpr(Ccode(RawMatrixOrNull, "(engine_RawMatrixOrNull)",
	       "IM2_Matrix_concat(", 
	       "(Matrix_array *)", getSequenceOfMatrices(e),
	       ")"))
     else WrongArg("a raw matrix or a sequence of raw matrices")
     );
setupfun("rawConcat",rawConcat);

rawDirectSum(e:Expr):Expr := (
     if isSequenceOfMatrices(e) then
     toExpr(Ccode(RawMatrixOrNull, "(engine_RawMatrixOrNull)",
	       "IM2_Matrix_direct_sum(", 
	       "(Matrix_array *)", getSequenceOfMatrices(e),
	       ")"))
     else WrongArg("a raw matrix or a sequence of raw matrices")
     );
setupfun("rawDirectSum",rawDirectSum);

rawMatrixColumns(e:Expr):Expr := (
     when e is f:RawMatrix do (
	  M := Ccode( RawFreeModule, "(engine_RawFreeModule)IM2_Matrix_get_source(", "(Matrix*)",f, ")" );
	  n := Ccode( int, "IM2_FreeModule_rank(", "(FreeModule*)",M, ")" );
	  Expr(new Sequence len n do for i from 0 to n-1 do provide toExpr(
		    Ccode(RawVectorOrNull, 
			 "(engine_RawVectorOrNull)",
			 "IM2_Matrix_get_column(",
			 "(Matrix *)", f, ",",
			 i,
			 ")"
			 )
		    )
	       )
	  )
     else WrongArg("a raw vector")
     );
setupfun("rawMatrixColumns",rawMatrixColumns);

rawMatrixEntry(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 3 then WrongNumArgs(3) else
     when s.0 is M:RawMatrix do
     when s.1 is r:Integer do 
     if !isInt(r) then WrongArg(2,"a small integer") else
     when s.2 is c:Integer do 
     if !isInt(c) then WrongArg(3,"a small integer") else (
	  Expr(Ccode(RawRingElement,
		    "(engine_RawRingElement)",
		    "IM2_Matrix_get_element(",
		    "(Matrix *)", M, ",",
		    toInt(r), ",",
		    toInt(c),
		    ")"
		    )
	       )
	  )
     else WrongArg(3,"an integer")
     else WrongArg(2,"an integer")
     else WrongArg(1,"a raw matrix")
     else WrongNumArgs(3)
     );
setupfun("rawMatrixEntry",rawMatrixEntry);



rawMatrixColumn(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0 is M:RawMatrix do
     when s.1 is c:Integer do 
     if !isInt(c) then WrongArg(2,"a small integer") else (
	  Expr(Ccode(RawVector,
		    "(engine_RawVector)",
		    "IM2_Matrix_get_column(",
		    "(Matrix *)", M, ",",
		    toInt(c),
		    ")"
		    )
	       )
	  )
     else WrongArg(2,"an integer")
     else WrongArg(1,"a raw matrix")
     else WrongNumArgs(2)
     );
setupfun("rawMatrixColumn",rawMatrixColumn);

rawTensor(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0
     is f:RawMatrix do
     when s.1 is g:RawMatrix do (
	  toExpr(Ccode(RawMatrixOrNull,"(engine_RawMatrixOrNull)",
		    "IM2_Matrix_tensor(",
		    "(Matrix *)", f, ",",
		    "(Matrix *)", g,
		    ")"
		    )
	       )		    
	  )
     else WrongArg(2,"a raw matrix")
     is M:RawFreeModule do
     when s.1 is N:RawFreeModule do (
	  toExpr(Ccode(RawFreeModuleOrNull,"(engine_RawFreeModuleOrNull)",
		    "IM2_FreeModule_tensor(",
		    "(FreeModule *)", M, ",",
		    "(FreeModule *)", N,
		    ")"
		    )
	       )		    
	  )
     else WrongArg(2,"a raw free module")
     else WrongArg(1,"a raw matrix or free module")
     else WrongNumArgs(2)     
     );
setupfun("rawTensor",rawTensor);

rawMatrixDiff(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0 is f:RawMatrix do
     when s.1 is g:RawMatrix do (
	  NotYet("diff")				    -- IM2_Matrix_diff
	  )
     else WrongArg(2,"a raw matrix")
     else WrongArg(1,"a raw matrix")
     else WrongNumArgs(2)     
     );
setupfun("rawMatrixDiff",rawMatrixDiff);

rawMatrixContract(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0 is f:RawMatrix do
     when s.1 is g:RawMatrix do (
	  NotYet("contract")				    -- IM2_Matrix_contract
	  )
     else WrongArg(2,"a raw matrix")
     else WrongArg(1,"a raw matrix")
     else WrongNumArgs(2)     
     );
setupfun("rawMatrixContract",rawMatrixContract);

rawIdentity(e:Expr):Expr := (
     when e
     is F:RawFreeModule do Expr(Ccode(RawMatrix, "(engine_RawMatrix)",
	       "IM2_Matrix_identity(", "(FreeModule *)", F, ")" ))
     else WrongArg("a raw free module"));
setupfun("rawIdentity",rawIdentity);

rawMonomials(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2) else
     if !isSequenceOfSmallIntegers(s.0) then WrongArg(1,"a sequence of small integers") else 
     when s.1 is M:RawMatrix do (
	  vars := getSequenceOfSmallIntegers(s.0);
	  toExpr(Ccode(RawMatrixOrNull, "(engine_RawMatrixOrNull)",
		    "IM2_Matrix_monomials(",
		    "(M2_arrayint)", vars, ",",
		    "(Matrix *)", M,
		    ")" ))
	  )
     else WrongArg(2,"a raw matrix")
     else WrongNumArgs(2));
setupfun("rawMonomials",rawMonomials);

rawCoefficients(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 3 then WrongNumArgs(3) else
     if !isSequenceOfSmallIntegers(s.0) then WrongArg(1,"a sequence of small integers") else
     if !isSequenceOfSmallIntegers(s.1) then WrongArg(2,"a sequence of small integers") else
     when s.2 is M:RawMatrix do (
	  vars := getSequenceOfSmallIntegers(s.0);
	  monoms := getSequenceOfSmallIntegers(s.1);
	  toExpr(Ccode(RawMatrixOrNull, "(engine_RawMatrixOrNull)",
		    "IM2_Matrix_get_coeffs(",
		    "(M2_arrayint)", vars, ",",
		    "(M2_arrayint)", monoms, ",",
		    "(Matrix *)", M,
		    ")" ))
	  )
     else WrongArg(3,"a raw matrix")
     else WrongNumArgs(3));
setupfun("rawCoefficients",rawCoefficients);

-----------------------------------------------------------------------------
-- monomial ideals

rawMonomialIdeal(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0 is m:RawMatrix do
     when s.1 is n:Integer do 
     if !isInt(n) then WrongArg(2,"a small integer") else 
     toExpr(Ccode(RawMonomialIdealOrNull, "(engine_RawMonomialIdealOrNull)",
	       "IM2_MonomialIdeal_make(", "(Matrix *)", m, ",", toInt(n), ")" ) )
     else WrongArg(2,"an integer")
     else WrongArg(1,"a raw matrix")
     else WrongNumArgs(2)
     );
setupfun("rawMonomialIdeal",rawMonomialIdeal);

rawNumgens(e:Expr):Expr := (
     when e
     is I:RawMonomialIdeal do Expr( toInteger(
	       Ccode(int, "IM2_MonomialIdeal_n_gens(", "(MonomialIdeal *)", I, ")" )))
     else WrongArg("a raw free module"));
setupfun("rawNumgens",rawNumgens);

rawIntersect(e:Expr):Expr := (
     when e is s:Sequence do
     when s.0 is I:RawMonomialIdeal do
     when s.1 is J:RawMonomialIdeal do
     toExpr(Ccode(RawMonomialIdealOrNull,"(engine_RawMonomialIdealOrNull)",
	       "IM2_MonomialIdeal_intersect(",
	       "(MonomialIdeal *)", I, ",",
	       "(MonomialIdeal *)", J,
	       ")"
	       )
	  )
     else WrongArg(2,"a raw monomial ideal")
     else WrongArg(1,"a raw monomial ideal")
     else WrongNumArgs(2)     
     );
setupfun("rawIntersect",rawIntersect);

-----------------------------------------------------------------------------
-- ring maps

rawRingMap(e:Expr):Expr := (
     when e
     is M:RawMatrix do Expr( Ccode( RawRingMap, "IM2_RingMap_make1(", "(Matrix*)",M, ")" ))
     else WrongArg("a raw matrix")
     );
setupfun("rawRingMap",rawRingMap);

rawRingMapEval(e:Expr):Expr := (
     when e
     is s:Sequence do
     if length(s) == 2 then 
     when s.0 is F:RawRingMap do 
     when s.1 is a:RawRingElement do (
	  toExpr(Ccode(RawRingElementOrNull,
		    "(engine_RawRingElementOrNull)",
		    "IM2_RingMap_eval_ringelem(",
		    "(RingMap *)", F, ",",
		    "(RingElement *)", a,
		    ")"
		    )
	       )
	  )
     else WrongArg(2,"a raw ring element")
     else WrongArg(1,"a raw ring map")
     else if length(s) == 3 then
     when s.0 is F:RawRingMap do 
     when s.1 is newTarget:RawFreeModule do
     when s.2
     is v:RawVector do (
	  toExpr(Ccode(RawVectorOrNull,
		    "(engine_RawVectorOrNull)",
		    "IM2_RingMap_eval_vector(",
		    "(RingMap *)", F, ",",
		    "(FreeModule *)", newTarget, ",",
		    "(Vector *)", v,
		    ")"
		    )
	       )
	  )
     is M:RawMatrix do (
	  toExpr(Ccode(RawMatrixOrNull,
		    "(engine_RawMatrixOrNull)",
		    "IM2_RingMap_eval_matrix(",
		    "(RingMap *)", F, ",",
		    "(FreeModule *)", newTarget, ",",
		    "(Matrix *)", M,
		    ")"
		    )
	       )
	  )
     else WrongArg(3,"a raw vector or matrix")
     else WrongArg(2,"a raw free module")
     else WrongArg(1,"a raw ring map")
     else buildErrorPacket("expected 2 or 3 arguments")
     else buildErrorPacket("expected 2 or 3 arguments")
     );
setupfun("rawRingMapEval",rawRingMapEval);
