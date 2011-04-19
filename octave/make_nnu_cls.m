nnu=read_chains('chains/wmap_act_apac_nnu_chains');
apac=read_chains('chains/wmap_act_apac_chains');
p1=mean(apac,1);p1=p1(3:end);
p2=mean(nnu,1);p2=p2(3:end);
[aa,bb]=get_sudeep_param_list;

i1=[1 2 4 8 6 9 21 22 23 ];
i2=[i1 13];
allp1=bb; for j=1:length(i1), allp1(i1(j))=p1(j);end;
allp2=bb; for j=1:length(i2), allp2(i2(j))=p2(j);end;
return
tic;cl1=get_cmb_spectrum(allp1,4500,0);toc
tic;cl2=get_cmb_spectrum(allp2,4500,0);toc
fid=fopen('cls_apac.txt','w');for ell=1:length(cl1),fprintf(fid,'%4d',ell+1);fprintf(fid,' %14.5f',cl1(ell,:));fprintf(fid,'\n');end;fclose(fid);
fid=fopen('cls_apac_nnu.txt','w');for ell=1:length(cl1),fprintf(fid,'%4d',ell+1);fprintf(fid,' %14.5f',cl2(ell,:));fprintf(fid,'\n');end;fclose(fid);

