#include <octave/oct.h>
#include <octave/Cell.h>
#include <iostream>
#include <stdio.h>
#include <stdbool.h>
#ifdef __cplusplus

#define N_CAMB_OUTPUT 6
extern "C"
{
#endif
#include <string.h>
#include <mc_var.h>

#include <fftw3.h>
#include <omp.h>
  void wmap_likelihood_init_();
  void wmap_likelihood_7yr_mp_wmap_likelihood_compute_(double *cltt,double *clte,double *clee,double *clbb,double *like);
  void __wmap_likelihood_7yr_MOD_wmap_likelihood_compute(double *cltt,double *clte,double *clee,double *clbb,double *like);
  void  __act_likelihood_2008_MOD_act_likelihood_init();
  void __act_likelihood_2008_MOD_act_likelihood_compute(double *cls, double *sz_amp, double *clustered_amp, double *src_amp, double *like);
  void __getspectra_MOD_getcambspectra(double *params,int *lmax,int *lens_flag,double *cltt,double *clee,double *clte,double *clbb,double *cltd,double *cldd,double *outvec,int *verbosity);

#ifdef __cplusplus
  
}  /* end extern "C" */
#endif

using namespace std;

/*--------------------------------------------------------------------------------*/
void *get_pointer(octave_value val)
{
  int64NDArray myptr=val.array_value();
  long myptr2=myptr(0,0);
  return (void *)myptr2;

}

/*--------------------------------------------------------------------------------*/

double get_value(octave_value val)
{
  NDArray myptr=val.array_value();
  double myval=(double)myptr(0,0);
  return myval;

}

/*--------------------------------------------------------------------------------*/
char *get_char_from_arg(charMatrix ch)
{
  int nn=ch.length();
  char *s=ch.fortran_vec();
  char *ss=strndup(s,nn+1);
  ss[nn]='\0';
  return ss;
}
/*--------------------------------------------------------------------------------*/
char *get_char_from_ov(octave_value cch)
{
  charMatrix ch=cch.char_matrix_value();

  int nn=ch.length();
  char *s=ch.fortran_vec();
  char *ss=strndup(s,nn+1);
  ss[nn]='\0';
  return ss;
}

/*--------------------------------------------------------------------------------*/
int matrix_nelem(Matrix mat)
{
  dim_vector dm=mat.dims();
  return dm(0)*dm(1);
}

/*--------------------------------------------------------------------------------*/

DEFUN_DLD (ccamb_hello, args, nargout, "Make sure library shows up.\n")
{
  //camb_hello();

  return octave_value_list();
}

/*--------------------------------------------------------------------------------*/
DEFUN_DLD(wmap_likelihood_c,args, nargout, "Calculate WMAP likelihood.\n")
{
  Matrix mcltt=args(0).matrix_value();
  Matrix mclte=args(1).matrix_value();
  Matrix mclee=args(2).matrix_value();
  Matrix mclbb=args(3).matrix_value();
  double *cltt=mcltt.fortran_vec();
  double *clte=mclte.fortran_vec();
  double *clee=mclee.fortran_vec();
  double *clbb=mclbb.fortran_vec();
  int num_wmap=10;
  Matrix like(num_wmap,1);
  double *llike=like.fortran_vec();
  memset(llike,0,num_wmap*sizeof(double));
  //wmap_likelihood_init_();
  //wmap_likelihood_7yr_mp_wmap_likelihood_compute_(cltt,clte,clee,clbb,&like);
  __wmap_likelihood_7yr_MOD_wmap_likelihood_compute(cltt,clte,clee,clbb,llike);
  return octave_value(like);

}


/*--------------------------------------------------------------------------------*/
#if 0

 DEFUN_DLD (ccamb_test, args, nargout, "Simple trial run.\n")
{
  struct Pstruct params;
  params.omega_b=0.025;
  params.omega_d=0.11;
  params.Omega_L=0.7;
  params.Omega_k=0;

  params.tauz=0.08;
  params.n_ad=0.98;

  params.A_s=2.3;
  params.a_iso=0;
  params.b_iso=0;
  params.n_iso=0;
  params.A_tens=0;
  params.n_run=0;
  params.sz_amp=0;
  params.w_lam=0;
  params.omega_n=0;
  params.N_nu=0;
  params.z_r=10;
  params.del_z=1;
  params.w_a=0;
  params.y_he=0.24;
  params.A_p=0;
  params.A_c=0;


  int nell=(int)get_value(args(0));
  Matrix cl(nell,4);
  
  int nk=get_nk_max();
  Matrix pk(nk,1);
  Matrix kvec(nk,1);
  Matrix out_vec(22,1);
  Matrix tscale(4,1);
  //dim_vector dm(nk,4,3);
  //NDArray lrg_vec(dm);
  Matrix lrg_vec(nk,4*3);

  double *vv=cl.fortran_vec();
  int nl_flag=2;
  int reion_flag=0;
  get_spectra((double *)&params,nl_flag,reion_flag,nell,vv,vv+nell,vv+2*nell,vv+3*nell,pk.fortran_vec(),kvec.fortran_vec(),out_vec.fortran_vec(),tscale.fortran_vec(),lrg_vec.fortran_vec());

  printf("Back from get_spectra.\n");

  return octave_value(cl);
  
}

#endif

/*--------------------------------------------------------------------------------*/
 DEFUN_DLD (init_act_likelihood, args, nargout, "Initialize ACT likelihood code\n")
{
  __act_likelihood_2008_MOD_act_likelihood_init();
  return octave_value_list();
  
}
/*--------------------------------------------------------------------------------*/
 DEFUN_DLD (get_act_likelihood_c, args, nargout, "Call ACT likelihood code\n")
{
  int num_act=2;
  Matrix like_mat(num_act,1);
  double *like=like_mat.fortran_vec();
  memset(like,0,sizeof(double)*num_act);
  Matrix cls_mat=args(0).matrix_value();
  double *cls=cls_mat.fortran_vec();

  double sz_amp=get_value(args(1));
  double clustered_amp=get_value(args(2));
  double source_amp=get_value(args(3));

  __act_likelihood_2008_MOD_act_likelihood_compute(cls,&sz_amp,&clustered_amp,&source_amp,like);
  return octave_value(like_mat);
}


/*--------------------------------------------------------------------------------*/
DEFUN_DLD (get_cmb_spectrum_c, args, nargout, "Call CAMB using Sudeep Das's interface.\n")
{


  Matrix params_mat=args(0).matrix_value();
  int lmax=3500;
  if (args.length()>=2)
    lmax=(int)get_value(args(1));
  int lens_flag=1;
  if (args.length()>=3)
    lens_flag=(int)get_value(args(2));
  double *params=params_mat.fortran_vec();
  Matrix cl(lmax,6);
  double *cltt=cl.fortran_vec();
  double *clee=cltt+lmax;
  double *clte=cltt+2*lmax;
  double *clbb=cltt+3*lmax;
  double *cltd=cltt+4*lmax;
  double *cldd=cltt+5*lmax;
  Matrix outparams(N_CAMB_OUTPUT,1);
  double *outvec=outparams.fortran_vec();
  int verbosity=0;
  if (args.length()>=4)
    verbosity=(int)get_value(args(3));

  __getspectra_MOD_getcambspectra(params,&lmax,&lens_flag,cltt,clee,clte,clbb,cltd,cldd,outvec,&verbosity);
  octave_value_list retval;
  retval(0)=octave_value(cl);
  retval(1)=octave_value(outparams);
  return retval;
}

#if 0
/*--------------------------------------------------------------------------------*/
 DEFUN_DLD (get_cmb_spectrum_c, args, nargout, "Call CAMB using Jo Dunkley's interface.\n")
{
  Matrix params_mat=args(0).matrix_value();
  int lmax;
  if (args.length()==1)
    lmax=3500;
  else
    lmax=(int)get_value(args(1));
  
  double *params=params_mat.fortran_vec();

  Matrix cl(lmax,4);
  
  int nk=get_nk_max();
  Matrix pk(nk,1);
  Matrix kvec(nk,1);
  Matrix out_vec(22,1);
  Matrix tscale(4,1);
  //dim_vector dm(nk,4,3);
  //NDArray lrg_vec(dm);
  Matrix lrg_vec(nk,4*3);

  double *vv=cl.fortran_vec();
  memset(vv,0,lmax*4*sizeof(double));
  int nl_flag=2;
  int reion_flag=0;
  get_spectra(params,nl_flag,reion_flag,lmax,vv,vv+lmax,vv+2*lmax,vv+3*lmax,pk.fortran_vec(),kvec.fortran_vec(),out_vec.fortran_vec(),tscale.fortran_vec(),lrg_vec.fortran_vec());

  //printf("Back from get_spectra.\n");

  return octave_value(cl);
  
}


/*--------------------------------------------------------------------------------*/


DEFUN_DLD (get_nk_max, args, nargout, "Find nkmax from camb.\n")
{
  int nk_max=get_nk_max();
  return octave_value(nk_max);
}
#endif
