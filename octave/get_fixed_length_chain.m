function[chain,accept,likes]=get_fixed_length_chain(func,params,cov_mat,nsamp,varargin)

np=numel(params.params);
chain=zeros(nsamp,np);
accept=zeros(nsamp,1);
likes=zeros(nsamp,1);
pcur=params.params;

lcur=feval(func,params,varargin{:});


dp=create_fake_data(cov_mat,nsamp)';

for j=1:nsamp,
  p_trial=pcur+dp(j,:);
  l_trial=feval(func,p_trial,varargin{:});
  if exp(lcur-l_trial)>rand,
    accept(j)=1;
    pcur=p_trial;
    lcur=l_trial;
  end
  chain(j,:)=pcur;
  likes(j)=lcur;
end
