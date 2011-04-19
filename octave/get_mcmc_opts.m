function[opts]=get_mcmc_opts(lines)

opts.minimize_first=pull_tag_eval(lines,'minimize_first',false);
opts.froot=pull_tag_eval(lines,'froot','chains/anonymous');
opts.chunk_time=pull_tag_eval(lines,'chunk_time',300);
opts.converge=pull_tag_eval(lines,'converge',0.02);