function[param_names,param_defaults]=get_sudeep_param_list()
  
pp= {'omega_b'  0.02258
    'omega_d'  0.1109
    'omega_nu' 0.0
    'Omega_L'  0.72
    'Omega_k'  0
    'n_ad'     0.96
    'n_run'    0
    'A_s'      2.49
    'tauz'     0.084
    'y_he'     0.24
    'w_0'     -1
    'w_a'      0
    'N_nu'     3.04
    'N_nu_massive'   0.0  
    'z_r'      10.0
    'del_z'     1.0
    'r'         0.0
    'n_iso'     0.0
    'a_iso'     0.0
    'b_iso'     0.0
    'sz_amp'    0.0
    'A_p'       0.0
    'A_c'       0.0};
param_names=pp(:,1);
param_defaults=cell2mat(pp(:,2));
