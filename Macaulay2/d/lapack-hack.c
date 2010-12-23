void xerbla_();
void lapack_hack () {
     xerbla_();
     }

/* in Ubuntu 10.10, liblapack and libblas both provide definitions of this symbol:

    /usr/lib/libblas/libblas.a(xerbla.o): In function `xerbla_':
    (.text+0x0): multiple definition of `xerbla_'
    /usr/lib/lapack/liblapack.a(xerbla.o):(.text+0x0): first defined here
    collect2: ld returned 1 exit status

We want the libblas version, so we call for it in this file, and link with

    -lblas -llapack -lblas

*/
