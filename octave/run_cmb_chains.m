addpath /project/rbond/sievers/act/octave2
mpi_init;

%Find the input script.  You can run this with octave --eval "input_script='fwee.ini';" run_my_first_wmap_chain_sudeep_sz.m
if ~exist('input_script'),
  input_script='trial_cmb_script_sz.ini';
end
lines=fuse_cell_lines(read_text_file_comments(input_script));

opts=get_mcmc_opts(lines);
params=setup_cmb_parameters(lines);
[data,params]=setup_data(lines,params);


fit_opts=optimset('TolX',1e-6);
%crud=get_chain_likelihood(params.params,params,data);
%return
%tic;[params_fit,FVAL]=fminunc(@get_chain_likelihood,params.params,fit_opts,params,data);


if (1)
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
end
run_simple_chains_mpi(params,data,opts.chunk_time,opts.froot,opts.converge);
return


%tic;[chain,accept,likes,params]=get_fixed_time_chain(params,data,120);toc