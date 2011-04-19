function[value]=find_1sig_errs(params,hess,func,varargin)

l0=feval(func,params,varargin{:});
tol=0.01;
dp_plus=0*params;
dp_minus=0*params;

for ip=1:length(params),
  dx=1/sqrt(hess(ip,ip));
  pp=0*params;pp(ip)=dx;

  while abs(l0-feval(func,params+pp,varargin{:}))<1,
    pp=pp*2;
  end
  %disp(['bracketed plus with ' num2str([ip pp(ip)])]);

  plow=0*pp;
  phigh=pp;
  pmid=0.5*pp;
  llow=l0;
  lhigh=feval(func,params+phigh,varargin{:});
  lmid=feval(func,params+pmid,varargin{:});
  ii=0;
  while abs(lmid-l0-1)>tol,
    ii=ii+1;
    if lmid-l0>1,
      phigh=pmid;
      lhigh=lmid;
      pmid=0.5*(plow+pmid);
    else
      plow=pmid;
      llow=lmid;
      pmid=0.5*(phigh+pmid);
    end
    lmid=feval(func,params+pmid,varargin{:});
  end
  %disp([num2str([ip pmid(ip) lmid-l0 ii])])
  dp_plus(ip)=pmid(ip);
end







for ip=1:length(params),
  dx=-dp_plus(ip);
  pp=0*params;pp(ip)=dx;

  while abs(l0-feval(func,params+pp,varargin{:}))<1,
    pp=pp*2;
  end
  %disp(['bracketed plus with ' num2str([ip pp(ip)])]);

  plow=0*pp;
  phigh=pp;
  pmid=0.5*pp;
  llow=l0;
  lhigh=feval(func,params+phigh,varargin{:});
  lmid=feval(func,params+pmid,varargin{:});
  ii=0;
  while abs(lmid-l0-1)>tol,
    ii=ii+1;
    if lmid-l0>1,
      phigh=pmid;
      lhigh=lmid;
      pmid=0.5*(plow+pmid);
    else
      plow=pmid;
      llow=lmid;
      pmid=0.5*(phigh+pmid);
    end
    lmid=feval(func,params+pmid,varargin{:});
  end
  %disp([num2str([ip pmid(ip) lmid-l0 ii dx])])
  dp_minus(ip)=pmid(ip);
end

value=0.5*(dp_plus-dp_minus);

%disp(dp_plus)
%disp(dp_minus)







