function[value]=pull_tag_eval(lines,tag,default)
if ~exist('default')
  default=nan;
end
value=default;
[tags,lines]=pull_one_tag(lines,tag);
if isempty(tags)
  return;
end
[a,b]=strtok(lines{end});
value=eval(b);

