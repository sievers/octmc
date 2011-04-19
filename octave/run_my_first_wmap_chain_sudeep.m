addpath /project/rbond/sievers/act/octave2
mpi_init;
lines=read_text_file_comments('trial_cmb_script.ini');

params=setup_cmb_parameters(lines);
[data,params]=setup_data(lines,params);
return


[like,params]=get_chain_likelihood(params.params,params,data);
run_simple_chains_mpi(params,data,300,'wmap_only_vanilla_test_sudeep',0.02);

%tic;[chain,accept,likes,params]=get_fixed_time_chain(params,data,120);toc