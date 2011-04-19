!>Defines various global parameters and strcutures
!>@author Sudeep Das, Berkeley

!>@version 1, 2011

module enums
  use camb
  use constants
  use precision
  
  integer, parameter :: LMAX_TENSOR = 500
  
  !General Input/Output Enums
  
  integer, parameter :: NPARAMSMAX = 25
 
  !Cosmological parameters
  integer, parameter :: I_OMEGA_B_H2 = 1
  integer, parameter :: I_OMEGA_C_H2 = 2
  integer, parameter :: I_OMEGA_NU_H2 = 3
  integer, parameter :: I_OMEGA_LAMBDA = 4
  integer, parameter :: I_OMEGA_K =5
  integer, parameter :: I_N_S = 6
  integer, parameter :: I_N_RUN = 7 
  integer, parameter :: I_A_S = 8  !Scalar amp x 1e9
  integer, parameter :: I_TAU = 9
  integer, parameter :: I_Y_P = 10
  integer, parameter :: I_W0 = 11
  integer, parameter :: I_WA = 12
  integer, parameter :: I_NU_MASSLESS = 13
  integer, parameter :: I_NU_MASSIVE = 14
  integer, parameter :: I_Z_REION = 15
  integer, parameter :: I_DELTA_Z_REION = 16
  integer, parameter :: I_A_TENS = 17 !T/S ratio
  
  ! Add more here (isocurvature)
  

  !! spectrum enums 
  integer, parameter :: INDEX_TT = 1
  integer, parameter :: INDEX_EE = 2
  integer, parameter :: INDEX_TE = 3
  integer, parameter :: INDEX_BB = 4
  integer, parameter :: INDEX_TD = 5
  integer, parameter :: INDEX_DD = 6

  
  !! OUTPUT ENUMS 
  integer, parameter  :: OUTPARAMSMAX = 6
  integer, parameter :: OUT_SIG8 = 1
  integer, parameter :: OUT_Z_REION =  2
  integer, parameter :: OUT_AGE =  3
  integer, parameter :: OUT_CL220 =  4
  integer, parameter :: OUT_Z_REC =  5
  integer, parameter :: OUT_T_REC =  6
  
end module Enums

  
