function[curlike,params]=get_cmb_chisq(pcur,params,datasets)
[curlike,params]=get_cmb_prior(pcur,params);
if ~isfinite(curlike)
  return;
end



for j=1:length(datasets),
  data=datasets{j};
  if strcmp(data.type,'WMAP')
    wmap_like=wmap_likelihood(params.cls(:,1),params.cls(:,3),params.cls(:,2),params.cls(:,4));
    curlike=curlike+sum(wmap_like);
  end
end
