function[data,params]=setup_data(lines_org,params)
%setup data.  there are a few classes of data this knows about, but in general, if it's not a known
%type, the second argument is the initialization function that will get called with the parameter structure, 
%then all remaining arguments (parameters goes in in case there are dataset-specific params to be added).  
%Function is assumed to return dataset and (potentially modified) parameter structure.



lines=get_param_lines(lines_org,'add_data ');
data={};
for j=1:length(lines),
  tags=strsplit(lines{j},' ',true);
  clear dd;
  %switch(tags{2})
  %  case{'WMAP'}
  %   dd.func=@wmap_likelihood;
  % otherwise
  myfunc=str2func(tags{2});
  %[dd,params]=eval(str2func(params,tags{2}),tags{3:end});
  [dd,params]=feval(myfunc,params,tags{3:end});
  %end
  data(end+1)={dd};
end





function[lines]=get_param_lines(lines,tag)
ind=false(length(lines));
if ~exist('tag'),
  tag='add_param ';
end

taglen=numel(tag);
for j=1:length(lines),
  if strncmp(lines{j},tag,taglen)
    ind(j)=true;
  end
end
lines=lines(ind);
