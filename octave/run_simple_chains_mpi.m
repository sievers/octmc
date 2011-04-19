function[value]=run_simple_chains_mpi(params,data,chunksize,outroot,rlim,varargin)

startpos=params.params;
mycov=params.cov_mat;

myid=mpi_comm_rank+1;
disp(['greetings from ' num2str(myid)])



converge=2*rlim;
fname=[outroot '_chains_' num2str(myid) '.txt'];

try
  crud=load(fname);
  big_chain=crud(:,3:end);
  big_like=crud(:,2);    
  big_multiplicity=crud(:,1);
  clear crud;
  fid=fopen(fname,'a');
  chain_frac=0.2;
  grand_chain=mpi_concatenate(big_chain(round(chain_frac*end):end,:));
  mycov=cov(grand_chain)*2.4^2/numel(startpos);

  if (myid==1)
    disp('starting cov:');
    disp(mycov);
  end
catch
  
  fid=fopen(fname,'w');
  big_chain=[];
  big_like=[];
  big_multiplicity=[];
end

chunk=0;
while converge>rlim,
  chunk=chunk+1;
  %[chain,accept,like]=get_fixed_length_chain(func,startpos,mycov,chunksize,varargin{:});
  [chain,accept,likes,params,derived_params]=get_fixed_time_chain(params,data,chunksize,varargin{:});
  [chain_small,like_small,mult_small,derived_small]=compress_chain_chunk(chain,accept,likes,derived_params);
  
  for j=1:length(like_small),
    fprintf(fid,'%5d %18.8e',mult_small(j),like_small(j));
    fprintf(fid,' %16.7g',chain_small(j,:));
    if ~isempty(derived_small),
      fprintf(fid,' %16.7g',derived_small(j,:));
    end


    fprintf(fid,'\n');
  end
  fflush(fid);
  big_chain=[big_chain;chain_small];
  big_like=[big_like;like_small];
  big_multiplicity=[big_multiplicity;mult_small];

  chain_frac=0.2;
  grand_chain=mpi_concatenate(big_chain(round(chain_frac*end):end,:));


  mycov=cov(grand_chain)*2.4^2/numel(startpos);
  params.cov_mat=mycov;
  startpos=chain(end,:);

  mymean=mean(big_chain(round(chain_frac*end):end,:),1);

  grand_mean=mpi_concatenate(mymean);
  mean_stds=std(grand_mean);
  chain_stds=std(grand_chain);
  converge=max(abs(mean_stds./chain_stds));
  if myid==1,
    disp(['convergence on chunk ' num2str(chunk) ' is ' num2str(converge)]);
  end



end
fclose(fid);
return
    