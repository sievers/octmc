.SUFFIXES: .f90 .o
#CC = gfortran -D__GFORTRAN__ -fPIC
FC = gfortran  
FFLAGS = -O2 -fPIC -c #-CB
OBJECTS = Enums.o GetSpectra.o
CAMBLIB = ../camb/
LDFLAGS = -L$(CAMBLIB) -lcamb #$(LAPACKLIB)/lapack_LINUX3.a $(LAPACKLIB)/blas_LINUX3.a 
INCFLAGS = -I$(CAMBLIB)
EXECUTABLE =TestInterface.x
LIBNAME=libcambinterface.a
.f90.o:
	$(FC) $(INCFLAGS) $(FFLAGS)  $<
default: lib $(EXECUTABLE)
lib: ${LIBNAME}

TestInterface.x: TestInterface.f90  
	$(FC) $(OBJECTS) $(INCFLAGS) -L. -lcambinterface $(LDFLAGS) $<  -o $@

${LIBNAME}:$(OBJECTS)
	ar rv $@ $^
#	ar rv libcambinterface.a *.o
doc:

clean:
	rm -rf *.o *mod *.x ${LIBNAME} $
