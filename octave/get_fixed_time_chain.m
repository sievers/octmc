function[chain,accept,likes,params,derived_params]=get_fixed_time_chain(params,data,tmax,varargin)


nsamp=1e5;  %no more than this many samples

np=numel(params.params);
chain=zeros(nsamp,np);
accept=zeros(nsamp,1);
likes=zeros(nsamp,1);
pcur=params.params;
if isfield(params,'derived_params'),
  derived_params=zeros(nsamp,numel(params.derived_params));
else
  derived_params=[];
end



dp=create_fake_data(params.cov_mat,nsamp)';  %sampling function done here.
[lcur,params]=get_chain_likelihood(pcur,params,data);



t_start=now;
for j=1:nsamp,
  p_trial=pcur+dp(j,:);
  [l_trial,params]=get_chain_likelihood(p_trial,params,data);

  if exp(lcur-l_trial)>rand,
    accept(j)=1;
    pcur=p_trial;
    lcur=l_trial;
    params.params=pcur;
  end
  chain(j,:)=pcur;
  likes(j)=lcur;
  if isfield(params,'derived_params'),
    derived_params(j,:)=params.derived_params;
  end

  t_stop=now;
  if (86400*(t_stop-t_start)>tmax)
    accept=accept(1:j);
    likes=likes(1:j);
    chain=chain(1:j,:);
    if isfield(params,'derived_params')
      derived_params=derived_params(1:j,:);
    end
    return
  end
end



