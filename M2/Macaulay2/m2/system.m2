--		Copyright 1995-2002 by Daniel R. Grayson

restart = Command ( 
     () -> (
	  runEndFunctions();
	  exec commandLine
	  )
     )

setRandomSeed = method()
setRandomSeed ZZ := seed -> (
     error "random seed not re-implemented yet";
     (callgg(ggrandomseed, seed);)
     )
setRandomSeed String := seed -> setRandomSeed fold((i,j) -> 101*i + j, 0, ascii seed)
