function[like,params]=get_cmb_prior(pcur,params)
like=0;
assert(numel(pcur)==numel(params.params));
for j=1:length(pcur),
  if pcur(j)<params.lims(j,1),
    like=inf;
    return;
  end
  if pcur(j)>params.lims(j,2),
    like=inf;
    return;
  end
end




%OK, made it this far.
pvec=params.all_params;
pvec(params.cmb_ind)=pcur(1:numel(params.cmb_ind));

Om=sum(pvec(params.h0_inds(1:2)));
om=sum(pvec(params.h0_inds(3:end)));
h0=100*sqrt(om/(1-Om));
%mdisp(['h0 is ' num2str(h0)]);
if (h0<40)|(h0>100)
  like=inf;
  return;
end


[params.cls,params.derived_params]=get_cmb_spectrum(pvec,params.lmax,params.do_lensing);

