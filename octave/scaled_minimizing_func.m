function[value]=scaled_minimizing_func(fitp,func,scale_vals,varargin)

value=feval(func,fitp.*scale_vals,varargin{:});

