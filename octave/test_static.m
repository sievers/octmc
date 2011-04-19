function[value]=test_static()
persistent am_i_initialized
if isempty(am_i_initialized)
  am_i_initialized=1;
  disp('initializing');
else
  disp('initialized');
end

