function[like,params]=get_chain_likelihood(pcur,params,data,scales)
if exist('scales'),
  pcur=pcur.*scales;
end

like=0;
for j=1:length(params.prior_funs),
  [dl,params]=feval(params.prior_funs{j},pcur,params,data);
  like=like+dl;
  if ~isfinite(like)
    return
  end
end
for j=1:length(data),
  dd=data{j};
  [dl]=feval(dd.func,pcur,params,dd);
  like=like+dl;
  if ~isfinite(like)
    return;
  end
end
