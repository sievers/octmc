program TestInterface
  use camb 
  use precision
  use GetSpectra
  use enums 
  
  real(dl) :: params(NPARAMSMAX)
  integer,parameter  :: lmax = 3000
  integer :: verbosity
  real(dl),dimension(2:lmax) :: cltt, clee, clte, clbb, cltd, cldd
  real(dl)                   :: derivedParams(OUTPARAMSMAX)
  
  lensFlag = 1
  
  params(I_OMEGA_B_H2) = 0.02258 
  params(I_OMEGA_C_H2) = 0.1109
  params(I_OMEGA_NU_H2) = 0.0
  params(I_OMEGA_K) = 0.0
  params(I_OMEGA_LAMBDA) = 0.72
  params(I_N_S) = 0.96
  params(I_N_RUN) = 0.0
  params(I_A_S) = 2.49
  params(I_TAU) = 0.084
  params(I_Y_P) = 0.24
  params(I_W0) = -1.
  params(I_WA) = 0.
  PARAMS(I_NU_MASSLESS) = 3.04 
  PARAMS(I_NU_MASSIVE) = 0.0
  params(I_Z_REION) = 10.
  params(I_DELTA_Z_REION) = 1.0
  params(I_A_TENS) = 0.0
  
  verbosity = 1
  
  call getCAMBSpectra(params,lmax,lensFlag,cltt,clee,clte,clbb,cltd,cldd,&
       & derivedParams, verbosity)
  print*, derivedParams 
end program TestInterface
