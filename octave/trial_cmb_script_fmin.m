froot chains/wmap_only_vanilla_test_fmin
minimize_first true


add_param omega_b 0.022 0.001  0 inf
add_param omega_d 0.113 0.03   0 inf
add_param Omega_L 0.72  0.10   0.0 1.0
add_param A_s     2.47  0.1    0 inf
add_param n_ad    0.963 0.01   0 2
add_param tauz    0.087 0.015  0.02 1.0
add_param sz_amp  1.0   0.5    0.00 2.0
set_param Omega_k 0

set_struct_opt lmax 2000
cov_mat_file wmap7_vanilla_sz_cov.txt


#cmb parameter parsing script knows about these option.
sz_spec_file /project/rbond/sievers/modules/v2a1s_likelihood/data_act/Fg/cl_sz_148_tbo1.dat
sz_freq 148
sz_columns 1 2

do_lensing 0



add_data setup_wmap
#add_data initialize_act_data

