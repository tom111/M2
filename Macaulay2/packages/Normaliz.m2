newPackage(
           "Normaliz",
           Version=>"0.1",
           Date=>"January 20, 2009",
           Authors=>{{Name=> "G. Kaempf",
                    Email=>"gkaempf@mathematik.uni-osnabrueck.de"}},
           Headline=>"a package to use Normaliz in Macaulay 2",
           DebuggingMode=> false,
	   AuxiliaryFiles => true
           )

export{setNmzExecPath, getNmzExecPath,
       setNmzVersion, getNmzVersion,
       setNmzFilename, getNmzFilename,
       setNmzDataPath, getNmzDataPath,
       setNmzFile,
       writeNmzPaths,
       startNmz, 
       rmNmzFiles,
       writeNmzData, readNmzData,
       getNumInvs, showNumInvs, exportNumInvs,
       setHilbOption, setVolOption, setCOption, setAllfOption, setSOption, setNOption, setPOption, setDOption,setIOption,
       hilbOption, volOption, cOption, allfOption, sOption, nOption, pOption, dOption,iOption,
       normaliz,
       mons2intmat, intmat2mons,
       normalToricRing, intclToricRing, ehrhartRing, intclMonIdeal
      }


-- initialising some values
nmzExecPath="";
nmzDataPath="";
nmzFilename="";
nmzVersion="";
nmzHilbOption=false;
nmzVolOption=false;
nmzCOption=false;
nmzAllfOption=false;
nmzSOption=false;
nmzNOption=false;
nmzPOption=false;
nmzDOption=false;
nmzIOption=false;
-------------------------------------------------------------

--  filenames and paths

-------------------------------------------------------------

-- sets the path to the executable for normaliz
setNmzExecPath=method()
setNmzExecPath String :=stringNmzExecPath->
(
 
 if(not stringNmzExecPath=="")
 then(
     if(not stringNmzExecPath#(#stringNmzExecPath-1)=="/")
     then(
            stringNmzExecPath=stringNmzExecPath|"/";
        );
    ); 
    nmzExecPath=stringNmzExecPath;
   
)

-- warning: if this variable is not set, this does not mean that there is no path set in the file nmzM2Exec.path. Use startNmz to check this!
getNmzExecPath=()->
(
       return nmzExecPath;
);

-- sets the version of the executable for normaliz
setNmzVersion=method()
setNmzVersion String:=stringNmzVersion->
(
    nmzVersion=stringNmzVersion;
);


getNmzVersion=()->
(
       return nmzVersion;
)

-- sets the filename for the exchange of data
setNmzFilename=method()
setNmzFilename String :=stringNmzFilename->
(
    nmzFilename=stringNmzFilename;
);


getNmzFilename=()->
(
       return nmzFilename;
)


-- sets the directory for the exchange of data
setNmzDataPath=method()
setNmzDataPath String :=stringNmzDataPath->
(
  if(not stringNmzDataPath=="")
    then(
        if(not stringNmzDataPath#(#stringNmzDataPath-1)=="/")
        then(
            stringNmzDataPath=stringNmzDataPath|"/";
        );
    ); 
    nmzDataPath=stringNmzDataPath;
  
);

-- warning: if this variable is not set, this does not mean that there is no path set in the file nmzM2Data.path. Use startNmz to check this!
getNmzDataPath=()->
(
       return nmzDataPath;
)



-- writes the path names into two files
writeNmzPaths=()->
(
    "nmzM2Exec.path" << nmzExecPath << close;
    "nmzM2Data.path" << nmzDataPath << close;
);


-- retrieves the path names written by writeNmzPaths() 
startNmz=()->
(
    if(not fileExists("nmzM2Exec.path"))
    then return "startNmz(): error. First call writeNmzPaths().";

    inf:="nmzM2Exec.path";
    s:=get inf;
    i:=#s;
    if(i==0)
    then(
         print "nmzExecPath not set";
    )
    else(
        t:=s#(i-1); 
        while(not (t=="/" or i==1))
        do( 
           i=i-1; 
           s=substring(0,i,s);
           t=s#(i-1);
        );
    
       if(i==1)
       then(
            print "nmzExecPath not set";
       )
       else( 
           nmzExecPath=s;
           print("nmzExecPath is "|nmzExecPath);
       );
   );

 if(not fileExists("nmzM2Data.path"))
    then return "startNmz(): error. First call writeNmzPaths().";
   inf="nmzM2Data.path";
    s=get inf;
    i=#s;
    if(i==0)
    then(
         print "nmzDataPath not set";
    )
    else(
        t=s#(i-1); 
        while(not (t=="/" or i==1))
        do( 
           i=i-1; 
           s=substring(0,i,s);
           t=s#(i-1);
        );
    
       if(i==1)
       then(
            print "nmzDataPath not set";
       )
       else( 
            nmzDataPath=s;
            print("nmzDataPath is " | nmzDataPath);
       );
   );
);


-- sets the file for the exchange of data
setNmzFile=()->
(
    if(not nmzFilename=="")
    then(
        nmzFile=nmzFilename;
    )
    else
    (
        nmzFile="nmzM2_"|processID();
    );

        nmzFile=nmzDataPath|nmzFile;
    return(nmzFile);
);



-- sets the version, by default it is norm64
setNmzExec=()->
(
    if(not nmzVersion=="")
    then(
        nmzExec=nmzVersion;  
    )
    else
    (
        nmzExec="norm64"; 
    );


        nmzExec=nmzExecPath|nmzExec;

    return(nmzExec);
);


-- removes the files created for and by normaliz
rmNmzFiles=()->
(
    suffixes:={"in","gen","out","sup","egn","esp","inv","tri","typ","hom"};
    for i from 0 to #suffixes-1 
    do(
      if(fileExists( getNmzFilename()|"."|suffixes#i))
      then removeFile(getNmzFilename()|"."|suffixes#i);
    );
);


---------------------------------------------------------

--  parsing normaliz output (not exported)

---------------------------------------------------------

-- returns true if c is a cipher or -
isCipher=method(TypicalValue=>Boolean)
isCipher String :=(c)->(
 cipher:="-0123456789";
  
  for i from 0 to 10 
  do(
      if(cipher#i==c) then return true;
  );
  return false; 
);

-- returns the next number in the string s, and the remaining string 
getNumber=method(TypicalValue=>(String,String))
getNumber String :=s->(
   r:="";
   while((not s=="") and isCipher(s#0))
   do(
      r=r|(s#0);  
      s=substring(1,#s-1,s);
   );
  return(r,s);
);

-- returns the next word (marked by whitespaces) in the string s, starting at position j and replaces "_" by " ", and the position of the first whitespace
-- if s contains no whitespace, the returned position is not in the string!
getKeyword=(s,j)->
(
  if(not s#(#s-1)==" ") then s=s|" "; -- geschummelt
  key:="";
  tmp:=s#j;
  while(not tmp==" ")
  do(
     if(tmp=="_") then tmp=" ";
      key=key|tmp;
      j=j+1;
      tmp=s#j;
  );
  return((key,j));  -- j=position whitespace
);

-- eliminates whitespaces and -, and transforms the next letter to upper case if possible
elimWhitespaces=s->
(
   tmp:="";
   i:=0;
   while(i<#s)
   do(
      if(s#i==" " or s#i=="-")
      then( 
           if(s#(i+1)==" " or s#(i+1)=="-")
           then( 
                i=i+1;
           )
           else( 
                tmp=tmp|toUpper(s#(i+1));
                i=i+2;
           );
      )
      else( 
           tmp=tmp|s#i;
           i=i+1;
      );
   );
   return tmp;  
);
-------------------------------------------------------------

-- input and output to/from normaliz

-------------------------------------------------------------

-- writes the given data in a normaliz input file
doWriteNmzData=method()
doWriteNmzData(Matrix, ZZ, ZZ):=(sgr, numCols, nMode)->
(
    outf:=setNmzFile() |".in" << "";  -- also sets the filename
    outf << numRows(sgr) << endl;
    outf << numCols << endl;

    for i from 0 to numRows(sgr)-1 
    do(
       s:="";
       for j from 0 to numCols-1 
       do(
          s=s|sgr_(i,j)|" ";
       ); 
       outf << s << endl;
    );

    outf << nMode << endl << close;
);

-- writes the given data in a normaliz input file
writeNmzData=method()
writeNmzData(Matrix,ZZ):=(sgr, nmzMode)->
(
    doWriteNmzData(sgr,numColumns(sgr), nmzMode);
);


-- reads the Normaliz output file with the specified suffix
-- suffix should not be inv or out or num
readNmzData=method(TypicalValue=>Matrix)
readNmzData(String):=(nmzSuffix)->
(
    if(nmzSuffix=="inv" or nmzSuffix=="out") 
    then return("error: to read .inv use getNumInvs(), to read .out there is no function provided");

    if(not fileExists(setNmzFile()|"."|nmzSuffix))
    then( 
         print "readNmzData:error: no file "|setNmzFile()|"."|nmzSuffix|" found"; 
         return();
    );

    inf:=get(setNmzFile()|"."|nmzSuffix);
    s=lines(inf);
    i:=0;
    if(i<#s)
    then(
         numRows:=value(s#i);
         i=i+1;
    );
    if(i<#s)
    then(
         numCols:=value(s#i);
         i=i+1;
    );
    nmzGen:={};
    t:="";
    while(i<#s)
    do( 
       gen={};
       j:=0;
       while(j+1<#(s#i))
       do(
          t=toString(s#i#j);
          j=j+1;
          while(j<#(s#i) and (not toString(s#i#j)==" "))
          do(
             t=t|s#i#j;
             j=j+1;
           );
        
        gen=append(gen,value t);
        );
     nmzGen=append(nmzGen,gen);
     i=i+1;
     );

     return(matrix(nmzGen));
);

-------------------------------------------------------------

-- retrieving normaliz numerical invariants

-------------------------------------------------------------

getNumInvs=()->
(
    numInvs:={};
    key:="";
    inv:=0;

    if(not fileExists(setNmzFile()|".inv"))
    then return "getNumInvs(): error: no file "|setNmzFile()|".inv"|" found.";

    inf:=get(setNmzFile()|".inv");  
    s:=lines(inf);
   
    for i from 0 to #s-1   -- for each line in the file
    do(
       key="";
       
       if(substring(0,7,s#i)=="integer")
       then( 
            (key,j)=getKeyword(s#i,8); 
             inv=(getNumber(substring(j+3,s#i)))#0;
       )
      else( if(substring(0,7,s#i)=="boolean")
            then(
                 (key,j)=getKeyword(s#i,8);
                  if(s#i#(j+3)=="t")
                  then( inv="true";)
                  else( inv="false";);
            )
            else (if(substring(0,6,s#i)=="vector")
                  then(
                       (len,str):=getNumber(substring(7,s#i)); 
                       (key,j)=getKeyword(str,1);
                       inv={}; 
                       en:="";
                       str=substring(j+10+#len,s#i);
                       while(not str=="")
                       do(
                          (en,str)=getNumber(str);
                          inv=append(inv,en);
                          str=substring(1,str);
                       );
                       inv=toSequence(inv);
                  );
           );
      );


    numInvs=append(numInvs,{key,inv});
    );
    return(numInvs);
);

-- types the numerical invariants on the standard output
showNumInvs=()->
(
    if(not fileExists(setNmzFile()|".inv"))
    then return "showNumInvs(): error: no file "|setNmzFile()|".inv"|" found.";

    l:=getNumInvs();
    for i from 0 to #l-1
    do(
       print(l#i#0|" : "|toString(l#i#1));
    );
);

-- makes the numerical invariants in the .inv file available to Macaulay 2, and prints them to the standard output, if the print option is true
opts={Print => false}
exportNumInvs=opts >> o->()->
(
    if(not fileExists(setNmzFile()|".inv"))
    then return "exportNumInvs(): error: no file "|setNmzFile()|".inv"|" found.";
  
   

  l:=getNumInvs();
  for i from 0 to #l-1
    do(
       value("nmz"|elimWhitespaces(" "|l#i#0)|"="|toString(l#i#1));
       if(o.Print)
       then(
            print ("nmz"|elimWhitespaces(" "|l#i#0)|"="|toString(l#i#1));
      );
    );

)
----------------------------------------------------------

-- running normaliz (with options)

----------------------------------------------------------

-- input: true or false 

setHilbOption=method()
setHilbOption Boolean :=onOff->
(
   if(onOff)
   then nmzHilbOption=true
   else nmzHilbOption=false;

);

setVolOption=method()
setVolOption Boolean :=onOff->
(
   if(onOff)
   then nmzVolOption=true
   else nmzVolOption=false;

);

setCOption=method()
setCOption Boolean :=onOff->
(
   if(onOff)
   then nmzCOption=true
   else nmzCOption=false;
);

setAllfOption=method()
setAllfOption Boolean :=onOff->
(
   if(onOff)
   then nmzAllfOption=true
   else nmzAllfOption=false;
);

setSOption=method()
setSOption Boolean :=onOff->
(
   if(onOff)
   then nmzSOption=true
   else nmzSOption=false;
);

setNOption=method()
setNOption Boolean :=onOff->
(
   if(onOff)
   then nmzNOption=true
   else nmzNOption=false;
);

setPOption=method()
setPOption Boolean :=onOff->
(
   if(onOff)
   then nmzPOption=true
   else nmzPOption=false;
);

setIOption=method()
setIOption Boolean :=onOff->
(
   if(onOff)
   then nmzIOption=true
   else nmzIOption=false;
);

setDOption=method()
setDOption Boolean :=onOff->
(
   if(onOff)
   then nmzDOption=true
   else nmzDOption=false;
);

hilbOption=()->
(
   return nmzHilbOption;
);

volOption=()->
(
    return(nmzVolOption);
);

cOption=()->
(
    return(nmzCOption);
);

allfOption=()->
(
    return(nmzAllfOption);
)

sOption=()->
(
    return(nmzSOption);
);

nOption=()->
(
    return(nmzNOption);
);

pOption=()->
(
    return(nmzPOption);
);

dOption=()->
(
    return(nmzDOption);
);

iOption=()->
(
    return(nmzIOption);
);

runNormaliz=method()
runNormaliz(Matrix,ZZ,ZZ):=(sgr,numCols, nmzMode)->
(
    doWriteNmzData(sgr,numCols,nmzMode);
    options:="";

        if(sOption())
        then(
             options=options|" -s ";
        );

        if(volOption())
        then(
             options=options|" -v ";  
        );

        if(nOption())
        then(
             options=options|" -n ";
        );

        if(pOption())
        then(
             options=options|" -p ";
        );

        if(hilbOption())
        then(
             options=options|" -h ";
        );

        if(dOption())
        then(
             options=options|" -d ";
        );

        if(iOption())
        then(
             options=options|" -i ";
        );


        if(cOption())
        then(
             options=options|" -c ";
        );

        if(allfOption())
        then(
             options=options|" -a ";
        );

    run(setNmzExec()|" -f "|options|nmzFile);


        if(volOption())
        then(
             return(); -- return nothing if volOption is on
        );
    return(readNmzData("gen"));

);


normaliz=method()
normaliz(Matrix,ZZ):=(sgr,nmzMode)->
(
    return(runNormaliz(sgr,numColumns(sgr),nmzMode));
);

-------------------------------------------------------------

-- intmats to/from monomials

-------------------------------------------------------------

mons2intmat=method()
mons2intmat Ideal :=I->
(
   
    mat:={};
    v:={};
    g:=gens I;     -- matrix with one row
    for i from 0 to numColumns(g)-1 
    do(
       v=(exponents(leadMonomial(g_(0,i))))#0;
       mat=append(mat,v);
    );
    return(matrix(mat));
);

-- expos: a matrix whose numColumns is <= numgens(r)
-- r: the ring where the ideal shall be
-- returns the ideal
intmat2mons=method()
intmat2mons(Matrix,Ring):=(expoVecs, r)->
(
   if(numColumns(expoVecs)< numgens(r))
   then(
        print("intmat2mons: not enough variables in the basering");
        return();
   );

   v:=vars(r);  -- the variables of the basering, a matrix with one row
   l:={};

   for i from 0 to numRows(expoVecs)-1
   do(
      m:=1;
      for j from 0 to numColumns(expoVecs)-1
      do(
         m=m*(v_(0,j))^(expoVecs_(i,j));
      );
      l=append(l,m);
   );
 
   return(ideal(l));

);

-- beachtet eine Zeile nur, wenn der letzte Eintrag 1 ist
-- muss den Ring als Parameter kriegen!
intmat2mons1=method(TypicalValue=>Ideal)
intmat2mons1(Matrix,Ring):=(expoVecs,r)->
(
   if(numColumns(expoVecs)< numgens(r))
   then(
        print("intmat2mons1: not enough variables in the basering");
        return();
   );
   v:=vars(r);  -- the variables of the basering, a matrix with one row
   l:={};

   for i from 0 to numRows(expoVecs)-1 
   do(
      if(expoVecs_(i,numColumns(expoVecs)-1)==1)
      then (
             m:=1;
             for j from 0 to numColumns(expoVecs)-2 
             do(
                 m=m*(v_(0,j))^(expoVecs_(i,j));
             );
             l=append(l,m);
      );
   );
   return(ideal(l));

);

-------------------------------------------------------------

-- integral closure of rings and ideals

-------------------------------------------------------------

runIntclToricRing=method()
runIntclToricRing(Ideal,ZZ):=(I,nmzMode)->
(
    expoVecs:=mons2intmat(I);
    if(volOption()) -- if volume option is on, return nothing
    then(
        runNormaliz(expoVecs,numColumns(expoVecs),nmzMode);
        return();
    );
    return( intmat2mons( runNormaliz(expoVecs,numColumns(expoVecs),nmzMode),ring(I) ) );
);

intclToricRing=method()
intclToricRing Ideal :=I->
(
    return(runIntclToricRing(I,0));
);

normalToricRing=method();
normalToricRing Ideal := I->
(
    return(runIntclToricRing(I,1));
);


runIntclMonIdeal=method()
runIntclMonIdeal(Ideal,ZZ):=(I,nmzMode)->
(
    expoVecs=mons2intmat(I);
    lastComp:=0;

    -- we test if there is room for the Rees algebra

    for i from 0 to numRows(expoVecs)-1
    do(
    
        if(not expoVecs_(i,numColumns(expoVecs)-1)==0)
        then(
            lastComp=1;  break; -- no
        );
    );

    if(volOption()) -- if volume option is on, return nothing
    then(
        runNormaliz(expoVecs,numColumns(expoVecs),nmzMode);
        return();
    );

    nmzData:=runNormaliz(expoVecs,numColumns(expoVecs)-1+lastComp,nmzMode);

    if(lastComp==1)
    then(
         I1=intmat2mons1(nmzData,ring(I)); 
         return(I1);  
    )
    else
    (
        I1=intmat2mons1(nmzData,ring(I));
        I2=intmat2mons(nmzData,ring(I));
       return({I1,I2});
    );
);


ehrhartRing=method()
ehrhartRing Ideal :=I->
(
    return(runIntclMonIdeal(I,2));
);

intclMonIdeal=method()
intclMonIdeal Ideal :=I->
(
    return(runIntclMonIdeal(I,3));
);


-------------------------------------------------------------
beginDocumentation()

document {
     Key => Normaliz,
     Headline => "an interface to use Normaliz in Macaulay 2",
     "The package ", EM "Normaliz"," provides an interface for the ues of ", TT "normaliz 2.1"," within Macaulay 2. The exchange of data is via files, the only possibility offered by ", TT "normaliz"," in its
present version. In addition to the top level functions that aim at objects of type ", TO "Ideal"," or ", TO "Ring",  ", several other auxiliary functions allow the user to apply ", TT "normaliz"," to data of type ", TO "Matrix","."  }



document {
     Key => {setNmzExecPath, (setNmzExecPath,String)},
     Headline => "sets the path to the executable for normaliz",
     Usage => "setNmzExecPath(s)",
     Inputs => {
           String => "a string containing the path" 
          },
     Consequences => {
          {"The function stores ", TT "s", " in the global variable holding the path name."}
         },
     "This is absolutely necessary if it is not in the search path. Note that the string should not contain ~or $ since Macaulay 2 seems to have problems with such paths.",
    EXAMPLE lines ///
        setNmzExecPath("$HOME/normaliz/bin");  -- Unix
        setNmzExecPath("d:/normaliz/bin"); -- Windows
        getNmzExecPath() 
        ///
        ,
     {"The last ", TT "/", " is added if necessary. The paths in the examples are veraltet."},
     SeeAlso => getNmzExecPath,
     }

document {
     Key => {getNmzExecPath},
     Headline => "returns the path to the executable for normaliz",
     Usage => "getNmzExecPath()",
     Outputs => {
           String => "the string containing the path"
          },
      "The default value is the empty string.",
    EXAMPLE lines ///
        getNmzExecPath()
        ///,
     Caveat =>{"This is the value stored in the global variable. The function ", TO startNmz, " retrieves the path names written by ", TO writeNmzPaths(), " to the hard disk, so this can be a different path." },
     SeeAlso=>setNmzExecPath
     }

document {
     Key => {setNmzVersion, (setNmzVersion,String)},
     Headline => "sets the version of the executable for normaliz",
     Usage => "setNmzVersion(s)",
     Inputs => {
           String => {"should be one of the following: ", TT "norm32", ", ", TT "norm64", ", or ", TT "normbig" }
          },
     "The default is ", TT "norm64",".",
    EXAMPLE lines ///
        setNmzVersion("normbig"); 
        getNmzVersion()
        setNmzVersion("norm32"); 
        ///
        ,
     SeeAlso => getNmzVersion
     }


document {
     Key => getNmzVersion,
     Headline => "returns the current version of normaliz to be used",
     Usage => "getNmzVersion()",
     Outputs => {
          String => "the current version of normaliz to be used"
          },
     EXAMPLE lines ///
          getNmzVersion()
          setNmzVersion("normbig");
          getNmzVersion()
          ///,
     SeeAlso => setNmzVersion,
     }

document {
     Key => {setNmzFilename, (setNmzFilename,String)},
     Headline => "sets the filename for the exchange of data",
     Usage => "setNmzFilename(s)",
     Inputs => {
           String => "the filename for the exchange of data"
          },
     {"By default, the package creates a filename ", TT "nmzM2_pid", ", where ", TT "pid", "is the process identification of the current ", TT "Macaulay 2", " process."},
    EXAMPLE lines ///
        setNmzFilename("VeryInteresting"); 
        getNmzFilename() 
        ///
        ,
     SeeAlso => getNmzFilename
     }


document {
     Key => getNmzFilename,
     Headline => "returns the current filename to be used",
     Usage => "getNmzFilename()",
     Outputs => {
          String => "the current filename to be used for the exchange of data"
          },
     EXAMPLE lines ///
          getNmzFilename()
          setNmzFilename("VeryInteresting");
          getNmzFilename()
          ///,
     SeeAlso => setNmzFilename
     }

document {
     Key => {setNmzDataPath, (setNmzDataPath,String)},
     Headline => "sets the directory for the exchange of data",
     Usage => "setNmzDataPath(s)",
     Inputs => {
           String => "the directory for the exchange of data"
          },
     {"By default it is the current directory.  Note that the string should not contain ~or $ since Macaulay 2 seems to have problems with such paths."},
    EXAMPLE lines ///
        setNmzDataPath("d:/normaliz/example"); 
        getNmzDataPath() 
        ///
        ,
     SeeAlso => getNmzDataPath,
   
     }


document {
     Key => getNmzDataPath,
     Headline => "returns the directory for the exchange of data",
     Usage => "getNmzDataPath()",
     Outputs => {
          String => "the path to the directory to be used for the exchange of data"
          },
     EXAMPLE lines ///
          getNmzDataPath()
          setNmzDataPath("d:/normaliz/example");
          getNmzDataPath()
          ///,
     Caveat =>{"This is the value stored in the global variable. The function ", TO startNmz, " retrieves the path names written by ", TO writeNmzPaths(), " to the hard disk, so this can be a different path." },
     SeeAlso => setNmzDataPath
     }

document {
     Key => setNmzFile,
     Headline => "sets the filename for the exchange of data",
     Usage => "setNmzFile()",
     Outputs => {
          String => "the path and the filename"
          },
     "This function concatenates the data path, if defined, and the filename created by ", TO "setNmzFilename", " and returns it.",
     EXAMPLE lines ///
          setNmzFile()
          ///,
     }


document {
     Key => writeNmzPaths,
     Headline => "writes the path names into two files",
     Usage => "writeNmzPaths()",
     "This function writes the path names into two files in the current directory. If one of the names has not been defined, the corresponding file is written, but contains nothing.",
     EXAMPLE lines ///
          writeNmzPaths();
          ///,
     SeeAlso => startNmz
     }

document {
     Key => startNmz,
     Headline => "initializes a session for normaliz",
     Usage => "startNmz()",
     "This function reads the files written by ", TO "writeNmzPaths", ", retrieves the path names, and types them on the standard output (as far as they have been set). Thus, once the path names have
been stored, a ", TT "normaliz", " session can simply be opened by this function.", 
     EXAMPLE lines ///
          startNmz();
          ///,
     SeeAlso => writeNmzPaths
     }

document {
     Key => rmNmzFiles,
     Headline => "removes the files created by normaliz",
     Usage => "rmNmzFiles()",
     "This function removes the files created for and by ", TT "normaliz", ", using the last filename created. These files are not removed automatically.",
     EXAMPLE lines ///
          rmNmzFiles();
          ///,
     }

document {
     Key => {writeNmzData, (writeNmzData, Matrix, ZZ)},
     Headline => "creates an input file for normaliz",
     Usage => "writeNmzData(sgr, nmzMode)",
     Inputs =>{
                Matrix => "generators of the semigroup",
                ZZ => "the mode"
      },
      Consequences => {"an input file filename.in is written, using the last filename created"}, 
     "This function creates an input file for ", TT "normaliz", ". The rows of ", TT "sgr", " are
considered as the generators of the semigroup. The parameter ", TT "nmzMode"," sets the mode.",
     EXAMPLE lines ///
          sgr=matrix({{1,2,3},{4,5,6},{7,8,10}})
          writeNmzData(sgr,1)
          nmzFile=setNmzFile()
          get(nmzFile|".in")
          rmNmzFiles();
          ///,
     SeeAlso => readNmzData
     }

document {
     Key => {readNmzData, (readNmzData, String)},
     Headline => "reads an output file of normaliz",
     Usage => "readNmzData(s)",
     Inputs => {
                String => "the suffix of the file to be read" 
     },
     Outputs => {
                 Matrix => " the content of the file"
     },
     "Reads an output file of ", TT "normaliz", " containing an integer matrix and returns it as an ", TO "Matrix", ". For example, this function is useful if one wants to inspect the support hyperplanes. The filename is
     created from the current filename in use and the suffix given to the function.",
     EXAMPLE lines ///
         sgr=matrix({{1,2,3},{4,5,6},{7,8,10}});
         normaliz(sgr,0)
         readNmzData("sup")
          ///,
     SeeAlso => {writeNmzData, normaliz}
     }

document {
     Key => {normaliz, (normaliz, Matrix, ZZ)},
     Headline => "applies normaliz",
     Usage => "normaliz(sgr,nmzMode)",
     Inputs => {
                Matrix => " the matrix",
                ZZ => " the mode"
     },
     Outputs => {Matrix => "generators of the integral closure"},
     "This function applies ", TT "normaliz", " to the parameter ", TT "sgr", " in the mode set by ", TT "nmzMode", ". The function returns the ", TO Matrix, " defined by the file with suffix ", TT "gen", " , if computed.",
     EXAMPLE lines ///
         sgr=matrix({{1,2,3},{4,5,6},{7,8,10}});
         normaliz(sgr,0)
          ///,
     SeeAlso => readNmzData
     }


document {
     Key => {getNumInvs},
     Headline => "returns the numerical invariants computed",
     Usage => "getNumInvs()",
     Outputs => {List => "the numerical invariants"},
     "This function returns a list whose length depends on the invariants available. The order of the elements in the list is always the same. Each list element has two parts. The first is a ", TO String, " describing the invariant, the second is the invariant, namely an ", TO ZZ, " for rank, index, multiplicity, a ", TO Sequence, " for the weights, the h-vector and the Hilbert polynomial and a ", TO Boolean, " for..."
     ,
     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          I=ideal(x^3,x^2*y,y^3);
          setHilbOption(true);
          intclMonIdeal(I);
          getNumInvs()
          ///,
     SeeAlso => {showNumInvs, exportNumInvs}
     }

document {
     Key => {showNumInvs},
     Headline => "prints the numerical invariants computed",
     Usage => "showNumInvs()",
     "This function types the numerical invariants on the standard output, but returns nothing. (It calls ", TO getNumInvs, ".)"
     ,
     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          I=ideal(x^3,x^2*y,y^3);
          setHilbOption(true);
          intclMonIdeal(I);
          showNumInvs()
          ///,
     SeeAlso => {getNumInvs, exportNumInvs}
     }

document {
     Key => {exportNumInvs},
     Headline => "makes the numerical invariants availabe to Macaulay 2",
     Usage => "exportNumInvs()",
     "This function exports the data read by ", TO getNumInvs, " into numerical ", TT "Macaulay 2", " data that can be accessed directly. For each invariant a variable of type ", TO ZZ, " or ", TO Sequence, " is created whose name is the first entry of each list element shown above, prefixed by ", TT "nmz", ". The variables created and their values are printed to the standard output."
     ,
     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          I=ideal(x^3,x^2*y,y^3);
          setHilbOption(true);
          intclMonIdeal(I);
          exportNumInvs()
          nmzHilbertBasisElements
          nmzHomogeneousWeights
          ///,
     SeeAlso => {getNumInvs, showNumInvs}
     }

document {
     Key => [exportNumInvs, Print],
     Headline => "wether to print the variables",
     Usage => "exportNumInvs(Print => true)",
     Inputs => {
               Boolean => "wether to print the variables created."
          },
     "If the ", TT "Print", " option is set to true, the function does not only create the variables, but also prints them to the standard output. The default is ", TT "false", ".",
     EXAMPLE lines ///
         R=ZZ/37[x,y,t];
          I=ideal(x^3,x^2*y,y^3);
          setHilbOption(true);
          intclMonIdeal(I);
          exportNumInvs()
          exportNumInvs(Print=> true)
          ///,
     }

document {
     Key => {setCOption, (setCOption, Boolean)},
     Headline => "sets the -c option",
     Usage => "setCOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-c", " option. The default is ", TT "false", "=off. Use ", TO cOption, " to obtain the current setting.",
     EXAMPLE lines ///
          cOption()  
          setCOption(true);  -- now it's on
          cOption()
          ///,
     SeeAlso => {cOption}
     }

document {
     Key => {cOption},
     Headline => "setting of the -c option",
     Usage => "cOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-c", " option is set, and ", TT "false", " otherwise.",
     EXAMPLE lines ///
          cOption() 
          setCOption(true);  -- now it's on
          cOption()
          ///,
     SeeAlso => {setCOption}
     }

document {
     Key => {setHilbOption, (setHilbOption, Boolean)},
     Headline => "sets the -h option",
     Usage => "setHilbOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-h", " option. The default is ", TT "false", "=off. Use ", TO hilbOption, " to obtain the current setting. Note that it does not make sense to turn on more than one of the options ", TT "s,v,n,p,h,d", ".",
     EXAMPLE lines ///
          hilbOption()  
          setHilbOption(true);  -- now it's on
          hilbOption()
          ///,
     SeeAlso => {hilbOption}
     }

document {
     Key => {hilbOption},
     Headline => "setting of the -h option",
     Usage => "hOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-h", " option is set, and ", TT "false", " otherwise.",
     EXAMPLE lines ///
          hilbOption() 
          setHilbOption(true);  -- now it's on
          hilbOption()
          ///,
     SeeAlso => {setHilbOption}
     }

document {
     Key => {setNOption, (setNOption, Boolean)},
     Headline => "sets the -n option",
     Usage => "setNOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-n", " option. The default is ", TT "false", "=off. Use ", TO nOption, " to obtain the current setting. Note that it does not make sense to turn on more than one of the options ", TT "s,v,n,p,h,d", "." ,
     EXAMPLE lines ///
          nOption()  
          setNOption(true);  -- now it's on
          nOption()
          ///,
     SeeAlso => {nOption}
     }

document {
     Key => {nOption},
     Headline => "setting of the -n option",
     Usage => "nOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-n", " option is set, and ", TT "false", " otherwise.",
     EXAMPLE lines ///
          nOption() 
          setNOption(true);  -- now it's on
          nOption()
          ///,
     SeeAlso => {setNOption}
     }

document {
     Key => {setPOption, (setPOption, Boolean)},
     Headline => "sets the -p option",
     Usage => "setPOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-p", " option. The default is ", TT "false", "=off. Use ", TO pOption, " to obtain the current setting. Note that it does not make sense to turn on more than one of the options ", TT "s,v,n,p,h,d", ".",
     EXAMPLE lines ///
          pOption()  
          setPOption(true);  -- now it's on
          pOption()
          ///,
     SeeAlso => {pOption}
     }

document {
     Key => {pOption},
     Headline => "setting of the -p option",
     Usage => "pOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-p", " option is set, and ", TT "false", " otherwise.",
     EXAMPLE lines ///
          pOption() 
          setPOption(true);  -- now it's on
          pOption()
          ///,
     SeeAlso => {setPOption}
     }

document {
     Key => {setSOption, (setSOption, Boolean)},
     Headline => "sets the -s option",
     Usage => "setSOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-s", " option. The default is ", TT "false", "=off. Use ", TO sOption, " to obtain the current setting. Note that it does not make sense to turn on more than one of the options ", TT "s,v,n,p,h,d", ".",
     EXAMPLE lines ///
          sOption()  
          setSOption(true);  -- now it's on
          sOption()
          ///,
     SeeAlso => {sOption}
     }

document {
     Key => {sOption},
     Headline => "setting of the -s option",
     Usage => "sOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-s", " option is set, and ", TT "false", " otherwise.",
     EXAMPLE lines ///
          sOption() 
          setSOption(true);  -- now it's on
          sOption()
          ///,
     SeeAlso => {setSOption}
     }

document {
     Key => {setVolOption, (setVolOption, Boolean)},
     Headline => "sets the -v option",
     Usage => "setVolOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-v", " option. The default is ", TT "false", "=off. Use ", TO volOption, " to obtain the current setting. Note that it does not make sense to turn on more than one of the options ", TT "s,v,n,p,h,d", ".",
     EXAMPLE lines ///
          volOption()  
          setVolOption(true);  -- now it's on
          volOption()
          ///,
     SeeAlso => {volOption}
     }

 document {
     Key => {volOption},
     Headline => "setting of the -v option",
     Usage => "volOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-v", " option is set, and ", TT "false", " otherwise." ,
     EXAMPLE lines ///
          volOption() 
          setVolOption(true);  -- now it's on
          volOption()
          ///,
     SeeAlso => {setVolOption}
     }

document {
     Key => {setDOption, (setDOption, Boolean)},
     Headline => "sets the -d option",
     Usage => "setDOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-d", " option. The default is ", TT "false", "=off. Use ", TO dOption, " to obtain the current setting. Note that it does not make sense to turn on more than one of the options ", TT "s,v,n,p,h,d", ".",
     EXAMPLE lines ///
          dOption()  
          setDOption(true);  -- now it's on
          dOption()
          ///,
     SeeAlso => {dOption}
     }

document {
     Key => {dOption},
     Headline => "setting of the -d option",
     Usage => "dOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-d", " option is set, and ", TT "false", " otherwise.",
     EXAMPLE lines ///
          dOption() 
          setDOption(true);  -- now it's on
          dOption()
          ///,
     SeeAlso => {setDOption}
     }

document {
     Key => {setIOption, (setIOption, Boolean)},
     Headline => "sets the -i option",
     Usage => "setIOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-i", " option. The default is ", TT "false", "=off. Use ", TO iOption, " to obtain the current setting. If this option is set, the setup file is ignored.",
     EXAMPLE lines ///
          iOption()  
          setIOption(true);  -- now it's on
          iOption()
          ///,
     SeeAlso => {iOption}
     }

document {
     Key => {iOption},
     Headline => "setting of the -i option",
     Usage => "iOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-i", " option is set, and ", TT "false", " otherwise.",
     EXAMPLE lines ///
          iOption() 
          setIOption(true);  -- now it's on
          iOption()
          ///,
     SeeAlso => {setIOption}
     }

document {
     Key => {setAllfOption, (setAllfOption, Boolean)},
     Headline => "sets the -a option",
     Usage => "setAllfOption(bool)",
     Inputs =>{ Boolean => "true=on, false=off"},
     "This function sets/resets the ", TT "-a", " option. The default is ", TT "false", "=off. Use ", TO allfOption, " to obtain the current setting.",
     EXAMPLE lines ///
          allfOption()  
          setAllfOption(true);  -- now it's on
          allfOption()
          ///,
     SeeAlso => {allfOption}
     }

document {
     Key => {allfOption},
     Headline => "setting of the -a option",
     Usage => "allfOption()",
     Outputs => {Boolean => "true=on, false=off"},
     "This function returns ", TT "true", " if the ", TT "-a", " option is set, and ", TT "false", " otherwise. Note that the ", TT "-a", " option is always set by default by the package. If ", TT "-a", " is set, it overrides the ", TT "-f", ".",
     EXAMPLE lines ///
          allfOption() 
          setAllfOption(true);  -- now it's on
          allfOption()
          ///,
     SeeAlso => {setAllfOption}
     }

document {
     Key => {mons2intmat, (mons2intmat, Ideal)},
     Headline => "matrix of leading exponents",
     Usage => "mons2intmat(I)",
     Inputs => { Ideal => "the ideal"},
     Outputs => {Matrix => {" rows represent the leading exponents of the generators of ", TT "I"}},
    "This function returns the ",TO Matrix, " whose rows represent the leading exponents of the elements of ", TT "I", ". The length of each row is the numbers of variables of the ambient ring of ", TT " I", ".",
     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          J=ideal(x^3, x^2*y, y^3, x*y^2,x*y^2*t^7);
          m=mons2intmat(J)
          I=intmat2mons(m,R)
          I==J
          ///,
     SeeAlso => {intmat2mons}
     }

document {
     Key => {intmat2mons, (intmat2mons, Matrix, Ring)},
     Headline => "monomials from a matrix",
     Usage => "intmat2mons(m,R)",
     Inputs => { Matrix => "a matrix, whose rows represent the exponent vectors",
                 Ring => "the ring, whose elements the monomials shall be"},
     Outputs => {Ideal => {"an ideal in ", TT "R", " generated by the monomials in ", TT "R", " whose exponent vectors are given by ", TT "m", "."}},
    " This functions interprets the rows of the matrix ", TT "m", " as exponent vectors of monomials in ", TT "R", ". It returns the ideal generated by these monomials.",
     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          m=matrix({{3,0,0},{2,1,0},{0,3,0},{1,2,7}})
          I=intmat2mons(m,R)
          J=ideal(x^3, x^2*y, y^3, x*y^2,x*y^2*t^7);
          I==J
     ///,
     SeeAlso => {mons2intmat}
     }

document {
     Key => {normalToricRing, (normalToricRing, Ideal)},
     Headline => "normalization of a toric ring",
     Usage => "normalToricRing(I)",
     Inputs => {Ideal => "the leading monomials of the elements of the ideal generate the toric ring"},
     Outputs => {Ideal => "the generators of the ideal are the generators of the normalization"},
    "This function computes the normalization of the toric ring generated by the leading monomials of the elements of ", TT "I", ". The function returns an ", TO Ideal, " listing the generators of the normalization.",BR{},BR{}, EM "A mathematical remark:", " the toric ring (and the other rings computed) depends on the list of monomials given, and not only on the ideal they generate!",
     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          I=ideal(x^3, x^2*y, y^3, x*y^2);
          normalToricRing(I)
     ///,
     }

document {
     Key => {intclToricRing, (intclToricRing, Ideal)},
     Headline => "integral closure of a toric ring",
     Usage => "intclToricRing(I)",
     Inputs => {
                Ideal => "the leading monomials of the elements of the ideal generate the toric ring"},
     Outputs => { 
                 Ideal => "the generators of the ideal are the generators of the integral closure"},
    "This function computes the integral closure of the toric ring generated by the leading monomials of the elements of ", TT "I", ". The function returns an ", TO Ideal, " listing the generators of the integral closure.",BR{},BR{}, EM "A mathematical remark:", " the toric ring (and the other rings computed) depends on the list of monomials given, and not only on
the ideal they generate!",
     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          I=ideal(x^3, x^2*y, y^3, x*y^2);
          intclToricRing(I)
     ///,
     }

document {
     Key => {ehrhartRing, (ehrhartRing, Ideal)},
     Headline => "Ehrhart ring",
     Usage => "ehrhartRing(I)",
     Inputs => {Ideal => "the leading monomials of the elements of the ideal are considered as generators of a lattice polytope"},
     "The exponent vectors of the leading monomials of the elements of ", TT "I", " are considered as generators of a lattice polytope. The function returns a list of ideals:", BR{}, BR{}, EM "(i)"," If the last ring variable is not used by the monomials, it is treated as the auxiliary variable of the Ehrhart ring. The function returns two ideals, the first containing the monomials representing the lattice points of the polytope, the second containing the generators of the Ehrhart ring.", BR{},BR{}, EM "(ii)", " If the last ring variable is used by the monomials, the function returns only one ideal, namely the monomials representing the lattice points of the polytope.",

     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          I=ideal(x^3, x^2*y, y^3, x*y^2);
          ehrhartRing(I)
          J=I+ideal(x*y^2*t^7);
          ehrhartRing(J)
     ///,
     }

document {
     Key => { intclMonIdeal, (intclMonIdeal, Ideal)},
     Headline => "Rees algebra",
     Usage => "intclMonIdeal(I)",
     Inputs => {Ideal => "the leading monomials of the elements of the ideal are considered as generators of a monomial ideal whose Rees algebra is computed"},
     "The exponent vectors of the leading monomials of the elements of ", TT "I"," are considered as generators of a monomial ideal whose Rees algebra is computed. The function returns a list of ideals:", BR{},BR{}, EM "(i)", " If the last ring variable is not used by the monomials, it is treated as the auxiliary variable of the Rees algebra. The function returns two ideals, the first containing the monomials generating the integral closure of the monomial ideal, the second containing the generators of the Rees algebra. ", BR{},BR{},EM "(ii)", " If the last ring variable is used by the monomials, it returns only one ideal, namely the monomials generating the integral closure of the ideal.",
     EXAMPLE lines ///
          R=ZZ/37[x,y,t];
          I=ideal(x^3, x^2*y, y^3, x*y^2);
          intclMonIdeal(I)
          J=I+ideal(x*y^2*t^7);
          intclMonIdeal(J)
     ///,
     }













