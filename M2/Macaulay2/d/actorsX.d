--		Copyright 1995 by Daniel R. Grayson

use X;
use C;
use system;
use err;
use stdio;
use stdiop;
use strings;
use nets;
use tokens;
use gmp;
use convertr;


-- X stuff
XCreateWindowfun(ee:Expr):Expr := (
     when ee is e:Sequence do
     if length(e) == 7 then
     when e.0 is parent:Integer do
     if isInt(parent) then
     when e.1 is x:Integer do
     if isInt(x) then
     when e.2 is y:Integer do
     if isInt(y) then
     when e.3 is width:Integer do
     if isInt(width) then
     when e.4 is height:Integer do
     if isInt(height) then
     when e.5 is borderwidth:Integer do
     if isInt(borderwidth) then
     when e.6 is name:string do
     Expr(toInteger(XCreateWindow(
		    uint(toInt(parent)),
		    toInt(x),
		    toInt(y),
		    toInt(width),
		    toInt(height),
		    toInt(borderwidth),
		    name)))
     else WrongArgString(6+1)
     else WrongArgSmallInteger(5+1)
     else WrongArgInteger(5+1)
     else WrongArgSmallInteger(4+1)
     else WrongArgInteger(4+1)
     else WrongArgSmallInteger(3+1)
     else WrongArgInteger(3+1)
     else WrongArgSmallInteger(2+1)
     else WrongArgInteger(2+1)
     else WrongArgSmallInteger(1+1)
     else WrongArgInteger(1+1)
     else WrongArgSmallInteger(0+1)
     else WrongArgInteger(0+1)
     else WrongNumArgs(7)
     else WrongNumArgs(7));
setupfun("XCreateWindow",XCreateWindowfun);

XDefaultRootWindowfun(e:Expr):Expr := Expr(toInteger(XDefaultRootWindow()));
setupfun("XDefaultRootWindow",XDefaultRootWindowfun);
