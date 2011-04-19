module GetSpectra
  use CAMB 
  use LambdaGeneral
  use enums 
  use Lensing
  
  
  implicit none
 
contains
  
  subroutine getCAMBSpectra(params,lmax,lensFlag,cltt,clee,clte,clbb,cltd,cldd,derivedParams, verbosity)
    
    real(dl)                   :: params(NPARAMSMAX)
    integer                    :: lmax 
    real(dl),dimension(2:lmax) :: cltt, clee, clte, clbb, cltd, cldd
    type(CAMBParams)           :: P
    real(dl)                   :: derivedParams(OUTPARAMSMAX)
    real(dl)                   :: output_factor, AGE, nu_frac, sigma8
    real(dl)                   :: clfac, tensfac, clfacPhiTemp(2:lmax), clfacPhi(2:lmax)
    integer                    :: i, lensFlag, verbosity
    
    
    call CAMB_SetDefParams(P)

    P%Max_l = lmax + 500
    P%Max_eta_k = 2._dl*P%Max_l
    
    output_factor = 1.0_dl
    
    w0_de = params(I_W0)
    wa_de = params(I_WA)
    cs2_lam = 1.0
    P%omegav = params(I_OMEGA_LAMBDA)
    
    P%H0 = 100._dl*sqrt((params(I_OMEGA_B_H2) + params(I_OMEGA_C_H2) + params(I_OMEGA_NU_H2))&
         &/(1._dl - P%omegav -params(I_OMEGA_K)))
    P%omegab = params(I_OMEGA_B_H2)/(P%H0/100._dl)**2
    P%omegan = params(I_OMEGA_NU_H2)/(P%H0/100._dl)**2
    P%omegac = params(I_OMEGA_C_H2)/(P%H0/100._dl)**2


    
    P%Num_Nu_massless = params(I_NU_MASSLESS)
    P%Num_Nu_massive  = params(I_NU_MASSIVE)
    if (P%Num_nu_massive .gt. 0) then 
       P%MassiveNuMethod = Nu_best
       P%Nu_mass_eigenstates = 1
       P%Nu_mass_degeneracies(1) = P%num_nu_massive
       P%Nu_mass_splittings = .true.
       P%Nu_mass_fractions(1)=1  
    end if
    P%tcmb = 2.726_dl
    P%yhe = params(I_Y_P)
    
    P%Scalar_initial_condition = initial_adiabatic 
    !!  No Isocurvature implemeneted yet
    
    P%Reion%Reionization = .true.
    P%Reion%use_optical_depth = .true.
    P%Reion%optical_depth = params(I_TAU)
    !print*, "reion ", P%Reion%optical_depth 
    P%Reion%delta_redshift =  params(I_DELTA_Z_REION)
    P%Reion%fraction= -1.0_dl
    
    P%InitPower%nn  = 1
    P%InitPower%an(1) = params(I_N_S)
    P%InitPower%n_run(1) = params(I_N_RUN)
    P%InitPower%ScalarPowerAmp(1) = params(I_A_S)*1.e-9
    P%InitPower%k_0_scalar= 0.002_dl
    P%InitPower%k_0_tensor = 0.002_dl
    
    FeedbackLevel = verbosity
    Age = CAMB_GetAge(P)

    if (FeedbackLevel > 0) then
       write (*,'("Age of universe/GYr  = ",f7.3)') Age
    end if
    
    
    P%AccuratePolarization = .true.
    P%AccurateReionization = .true.    
    P%DoLensing = .false.  
    if (lensFlag == 0) P%DoLensing = .true.
    
    P%WantTransfer=.true.
    P%WantScalars = .true.
    P%WantVectors = .false.
    P%WantTensors = .false.
    
    if(params(I_A_TENS) .gt. 0.) then
       P%WantTensors = .true. 
       P%Max_l_tensor = LMAX_TENSOR
       P%Max_eta_k_tensor = 2.d0*LMAX_TENSOR
       P%InitPower%ant(1) = (-1.0_dl)*params(I_A_TENS)/8.       
       P%InitPower%rat(1) = params(I_A_TENS)
    endif
    
    !print*, P%WantTensors, P%doLensing 
    
    P%OutputNormalization=outNone
    P%WantCls= P%WantScalars .or. P%WantTensors .or. P%WantVectors
    
    
    if (.not. CAMB_ValidateParams(P)) stop 'Stopped due to parameter error'
    !print*, "one"
    call CAMB_GetResults(P)
    !print*, "two"
    
    clfac =  7.4311e12
    do i = 2,lmax
       clfacPhi(i) = (real(i,dl)**4)/(real(i,dl)*(real(i,dl)+1.))
       clfacPhiTemp(i) = (real(i,dl)**3)/sqrt(real(i,dl)*(real(i,dl)+1.))
    end do
    
    
    cltt(2:lmax) = Cl_scalar(2:lmax,1,C_Temp)*clfac
    clee(2:lmax) = Cl_scalar(2:lmax,1,C_E)*clfac
    clte(2:lmax) = Cl_scalar(2:lmax,1,C_Cross)*clfac
    clbb(2:lmax) = 0.0_dl
    cldd(:) = 0._dl
    cltd(:) = 0._dl
    
    If (P%doLensing) then
       clTd(2:lmax) = real(Cl_scalar(2:lmax,1,C_PhiTemp),dl)/clfacPhiTemp(2:lmax)
       cldd(2:lmax) = real(Cl_scalar(2:lmax,1,C_Phi),dl)/clfacPhi(2:lmax)
       cltt(2:lmax) = Cl_lensed(2:lmax,1,CT_Temp)*clfac
       clee(2:lmax) = Cl_lensed(2:lmax,1,CT_E)*clfac
       clte(2:lmax) = Cl_lensed(2:lmax,1,CT_Cross)*clfac
       clbb(2:lmax) = Cl_lensed(2:lmax,1,CT_B)*clfac
    end If
    
    if (P%WantTensors) then 
       cltt(2:P%Max_l_tensor) = cltt(2:P%Max_l_tensor)+ Cl_tensor(2:P%Max_l_tensor,1,CT_Temp)*clfac
       clee(2:P%Max_l_tensor) = clee(2:P%Max_l_tensor)+ Cl_tensor(2:P%Max_l_tensor,1,CT_E)*clfac
       clte(2:P%Max_l_tensor) = clte(2:P%Max_l_tensor)+ Cl_tensor(2:P%Max_l_tensor,1,CT_Cross)*clfac
       clbb(2:P%Max_l_tensor) = clbb(2:P%Max_l_tensor)+ Cl_tensor(2:P%Max_l_tensor,1,CT_B)*clfac
    end if
    
    ! Derived Params 
    
    derivedParams(:) = 0._dl
    derivedParams(OUT_SIG8) = MT%sigma_8(1,1)
    derivedParams(OUT_AGE) = Age
    derivedParams(OUT_CL220) =cltt(220)
    derivedParams(OUT_Z_REION) = P%Reion%redshift
    derivedParams(OUT_T_REC) = tau_maxvis
    derivedParams(OUT_Z_REC) = 1100. !! Should be changed to a function call
    
    call CAMB_cleanup
    
  end subroutine getCAMBSpectra
end module GetSpectra
