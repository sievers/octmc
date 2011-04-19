function[data,params]=initialize_act_data(params,varargin)

%initialize ACT data, but only do it once.  Thanks, Fortran.
persistent initialized
if isempty(initialized)
  init_act_likelihood;
  initialized=1;
else
  disp('attempted to re-initialize act data.  Skipping.');
end



data.func=@get_act_likelihood;
data.lmax=10000;
data.sz_ind=find_cell_ind('sz_amp',params.all_names);
data.src_ind=find_cell_ind('A_p',params.all_names);
data.clustered_ind=find_cell_ind('A_c',params.all_names);

return


function[j]=find_cell_ind(tag,vals)
for j=1:length(vals),
  if strcmp(tag,vals{j})
    return
  end
end
j=0;

