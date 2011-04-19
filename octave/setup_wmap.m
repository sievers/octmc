function[data,params]=setup_wmap(params,varargin)
data.func=@wmap_likelihood;
if isfield(params,'sz_spec'),
  data.do_sz=true;
  for j=1:length(params.all_names),
    if strcmp('sz_amp',params.all_names{j}),
      data.sz_ind=j;
    end
  end
  if isfield(params,'sz_freq'),
    sz_template_freq=params.sz_freq;
  else
    sz_template_freq=30;
    warning(['SZ template frequency not found in parameter structre, but it appears to be requested.  Defaulting to 30.']);
  end
  wmap_freq=90;  %as per Nolta's suggestion
  
  data.sz_scale_fac=(sz_fac_kompaneets(wmap_freq)/sz_fac_kompaneets(sz_template_freq))^2;
  
  
else
  data.do_sz=false;
end

