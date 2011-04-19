function[totlike,like]=get_act_likelihood(pp,params,data)
pvec=params.all_params;
pvec(params.cmb_ind)=pp(1:length(params.cmb_ind));

cls_tt=params.cls(:,1);
if numel(cls_tt)<data.lmax,
  cls_tt(data.lmax)=0;
end
sz_amp=pvec(data.sz_ind);
src_amp=pvec(data.src_ind);
clustered_amp=pvec(data.clustered_ind);

like=get_act_likelihood_c(cls_tt,sz_amp,clustered_amp,src_amp);
totlike=sum(like);