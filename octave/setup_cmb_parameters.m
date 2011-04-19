function[params]=setup_cmb_parameters(lines_org,params)
if ~exist('params')
  params=initialize_parameter_struct;
end
params.prior_funs(end+1)={@get_cmb_prior};


[param_names,param_defaults]=get_sudeep_param_list;


params.all_params=[params.all_params param_defaults];
params.all_names=[params.all_names param_names];
%params.param_names(end+1:end+numel(param_names))=param_names;
np_org=numel(params.params);

lines=get_param_lines(lines_org,'add_param ');
for j=1:length(lines),
  tags=strsplit(lines{j},' ',true);
  ind=find_tag_ind(tags{2},param_names);
  if (ind>0)
    params.cmb_ind(j)=ind+np_org;
    params.params(j+np_org)=str2num(tags{3});
    params.stds(j+np_org)=str2num(tags{4});
    params.lims(j+np_org,1)=str2num(tags{5});
    params.lims(j+np_org,2)=str2num(tags{6});
    params.names(end+1)=tags(2);
  else
    disp(['skipping parameter ' tags{2} ' in setup_cmb_parameters.']);
  end
end

lines=get_param_lines(lines_org,'set_param ');
for j=1:length(lines),  
  tags=strsplit(lines{j},' ',true);
  ind=find_tag_ind(tags{2},param_names);
  if (ind>0)
    params.all_params(ind)=str2num(tags{3});
  else
    disp(['skipping setting parameter ' tags{2} ' in setup_cmb_parameters.']);
  end
end

lines=get_param_lines(lines_org,'set_struct_opt');
for j=1:length(lines),
  tags=strsplit(lines{j},' ',true);
  to_eval=['params.' tags{2} ' = ' tags{3} ';'];
  eval(to_eval);
end

[tags,ll]=pull_one_tag(lines_org,'cov_mat_file');
if isempty(tags),
  params.cov_mat=diag(params.stds.^2)*2.4^2/numel(params.params);
else
  try
    params.cov_mat=load(tags{2});
  catch
    %if it's not just a filename, we're assuming there's code in the script to setup params.cov_mat
    [aa,bb]=strtok(ll{end});
    eval(bb);
    assert(~isempty(params.cov_mat));
  end
  assert(issquare(params.cov_mat));
  if length(params.cov_mat)~=numel(params.params),
    warning(['assigned covariance matrix does not match current # of parameters.  This is hopefully expected.']);
  end
end




h0_tags={'Omega_k','Omega_L','omega_b','omega_d','omega_nu'};
h0_inds=zeros(size(h0_tags));
for j=1:length(h0_tags),
  for k=1:length(params.all_names),
    if strcmp(h0_tags{j},params.all_names{k}),
      h0_inds(j)=k;
    end
  end
end


assert(min(h0_inds)>0);  %this says we found all of 'em
params.h0_inds=h0_inds;



tags=pull_one_tag(lines_org,'do_lensing');
if ~isempty(tags),
  params.do_lensing=str2num(tags{2});
else
  warning('did not find lensing specified.  Defaulting to zero (on).');
  params.do_lensing=0;
end




%see if SZ power spectrum has been requested
tags=pull_one_tag(lines_org,'sz_spec_file');
if ~isempty(tags),
  sz_spec=load(tags{2});
  tags=pull_one_tag(lines_org,'sz_columns');
  if ~isempty(tags),
    if numel(tags)==2,
      clsz=sz_spec(:,str2num(tags{2}));
    end
    if numel(tags)==3,
      ell=sz_spec(:,str2num(tags{2}));
      cl=sz_spec(:,str2num(tags{3}));
      if max(abs(diff(ell)-1))>0, %the ells aren't uniformly spaced
        disp(['Doing interpolation on SZ file.  We hope you expect this.']);
        ell_use=(2:round(max(ell)))';
        clsz=interp1(ell,cl,ell_use,'spline');
      else
        clsz(ell)=cl;
      end
    end
  else
    warning(['using the last column in SZ file.  I hope that''s what you wanted.']);
    clsz=sz_spec(:,end);  %we'll use the last column.  You haven't given me much to go on.
  end
  params.sz_spec=clsz;
  params.sz_freq=30;  %in the absence of further info, assume 30 GHz, close to RJ.  
  tags=pull_one_tag(lines_org,'sz_freq');
  if ~isempty(tags),
    params.sz_freq=str2num(tags{2});
  end
end


       

%params.lmax=1300;  %minimum for WMAP

    







function[found]=is_tag(tag,lines)
found=true;
taglen=numel(tag);
for j=1:length(lines),
  if strncmp(tag,lines{j},taglen)
    return;
  end
end
found=false;
return



function[ind]=find_tag_ind(mystr,tags)
for ind=1:length(tags)
  if strcmp(mystr,tags{ind})
    return;
  end
end
ind=0; %not found
return