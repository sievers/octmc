function[value]=wmap_likelihood(pp,params,data)

pvec=params.all_params;
pvec(params.cmb_ind)=pp(1:numel(params.cmb_ind));


cls_tt=params.cls(:,1);
if data.do_sz,
  sz_vec=params.sz_spec*pvec(data.sz_ind);
  cls_tt=add_vecs_safe(cls_tt,params.sz_spec*pvec(data.sz_ind));
end
%wmap_like=wmap_likelihood_c(params.cls(:,1),params.cls(:,3),params.cls(:,2),params.cls(:,4));
wmap_like=wmap_likelihood_c(cls_tt,params.cls(:,3),params.cls(:,2),params.cls(:,4));
value=sum(wmap_like);
