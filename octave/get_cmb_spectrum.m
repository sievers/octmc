function[pp,otherp]=get_cmb_spectrum(params,lmax=3900,do_lensing=1)
%use Jo Dunkley's code to get parameters into CAMB and spectra out.
%JLS Feb 23 2011, now using Sudeep Das's interface.
if ~exist('params'),
  params=[];
end



if isnumeric(params)
  assert(numel(params)>=20) %this is how many jo's code expects extra params at end will get ignored.
  %disp(['tau is ' num2str(params(5))]);
  %disp(params(1:9)')
  [pp,otherp]=get_cmb_spectrum_c(params,lmax,do_lensing);
  otherp=otherp';  %better for stacking in chains.
  return
end





param_names=get_dunkley_param_list();

params=set_default_camb_params(params,param_names);
pp=zeros(length(param_names),1);
for j=1:length(pp),
  eval(['pp(' num2str(j) ')=params.' param_names{j} ';']);
end

return

function[params]=set_default_camb_params(params,names)

my_defaults=[
0.02258
0.1109
0.734
0
0.088
0.963
2.3
0
0
0
0
0
0
0
0
0
10
1
0
0.24
0
0];
if ~isstruct(params)
  params=[];
  disp(['Warning - input params was not a structure in get_cmb_spectrum.  Overwriting with default.']);
end

if isempty(params),
  params.omega_b=my_defaults(1);
end

for j=1:length(names),
  mystr=['params.' names{j} '=' num2str(my_defaults(j)) ';'];
  %disp(mystr)
  if ~isfield(params,names{j})
    eval(mystr);
  end
end
