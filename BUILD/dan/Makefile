production:;	time make -f Makefile.mac DEBUG=no  M64=yes
check:; 	time make -f Makefile.mac DEBUG=no  M64=yes -o install IgnoreExampleErrors=true check
clean:;		make -f Makefile.mac DEBUG=yes M64=yes $@


debugging:;	time make -f Makefile.mac DEBUG=yes M64=yes -o check -o install IgnoreExampleErrors=true RerunExamples=true
debcheck:; 	time make -f Makefile.mac DEBUG=yes M64=yes -o install check


#  IgnoreExampleErrors=true RemakeAllDocumentation=true RemakePackages=true

