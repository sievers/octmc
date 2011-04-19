
apac=read_chains('chains/wmap_act_apac_chains');
p1=mean(apac,1);p1=p1(3:end);
[nms,bb]=get_sudeep_param_list;

i1=[1 2 4 8 6 9 21 22 23 ];
allp1=bb; for j=1:length(i1), allp1(i1(j))=p1(j);end;
if (1)
  %omb=1e-3:1e-3:5e-2;
  omb=[];
  omb2=1.9e-2:2e-4:2.5e-2;
  omb=sort(unique([omb omb2]));
  for j=length(omb):-1:1,
    t1=now;
    use_param=allp1;use_param(1)=omb(j);
    cls=get_cmb_spectrum(use_param,4000,0);
    outname=sprintf('cls/cls_act_wmap7_omb_%0.4f.txt',omb(j));
    cls=get_cmb_spectrum(use_param,4200,0);
    fid=fopen(outname,'w');
    for k=1:length(cls),
      fprintf(fid,'%5d %14.3f\n',k,cls(k,1));
    end
    fclose(fid);
    t2=now;
    disp(num2str([j 86400*(t2-t1)]));
  end
  return
end


omc=0.02:0.004:0.2;
omc2=0.09:0.001:0.14;
omc=sort(unique([omc omc2]));
for j=length(omc):-1:1,
  t1=now;
  use_param=allp1;use_param(2)=omc(j);
  cls=get_cmb_spectrum(use_param,4000,0);
  outname=sprintf('cls/cls_act_wmap7_omc_%0.3f.txt',omc(j));
  cls=get_cmb_spectrum(use_param,4200,0);
  fid=fopen(outname,'w');
  for k=1:length(cls),
    fprintf(fid,'%5d %14.3f\n',k,cls(k,1));
  end
  fclose(fid);
  t2=now;
  disp(num2str([j 86400*(t2-t1)]));
end




return
tic;cl1=get_cmb_spectrum(allp1,4500,0);toc
tic;cl2=get_cmb_spectrum(allp2,4500,0);toc
fid=fopen('cls_apac.txt','w');for ell=1:length(cl1),fprintf(fid,'%4d',ell+1);fprintf(fid,' %14.5f',cl1(ell,:));fprintf(fid,'\n');end;fclose(fid);
fid=fopen('cls_apac_nnu.txt','w');for ell=1:length(cl1),fprintf(fid,'%4d',ell+1);fprintf(fid,' %14.5f',cl2(ell,:));fprintf(fid,'\n');end;fclose(fid);

