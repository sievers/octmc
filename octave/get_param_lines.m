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
