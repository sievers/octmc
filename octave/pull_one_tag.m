function[tags,lines]=pull_one_tag(lines,tag)
lines=get_param_lines(lines,tag);
tags={};
if isempty(lines)
  return;  %we didn't find anything
end
if numel(lines)>1
  warning(['Found multiple entries pulling tag ' tag '.  Using final entry']);
  lines=lines(end);
end
tags=strsplit(lines{1},' ',true);
return
