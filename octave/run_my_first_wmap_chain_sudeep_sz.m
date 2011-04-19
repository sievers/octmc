addpath /project/rbond/sievers/act/octave2
mpi_init;

%Find the input script.  You can run this with octave --eval "input_script='fwee.ini';" run_my_first_wmap_chain_sudeep_sz.m
if ~exist('input_script'),
  input_script='trial_cmb_script_sz.ini';
end
lines=read_text_file_comments(input_script);

params=setup_cmb_parameters(lines);
[data,params]=setup_data(lines,params);
froot=pull_one_tag(lines,'froot');
if isempty(froot),
  froot='wmap_only_vanilla_test_sudeep_sz_default';
else
  froot=froot{2};
end


%params.params=params.params+(create_fake_data(params.cov_mat))';
iter=0;
like=inf;
while ~isfinite(like)
  iter=iter+1;
  pp=params.params+(create_fake_data(params.cov_mat))';
  [like,params]=get_chain_likelihood(pp,params,data);
  if iter>100
    error(['unable to find valid starting point after ' num2str(iter) ' tries.']);
  end
end
assert(isfinite(like));
params.params=pp;

run_simple_chains_mpi(params,data,300,froot,0.02);
return


%tic;[chain,accept,likes,params]=get_fixed_time_chain(params,data,120);toc