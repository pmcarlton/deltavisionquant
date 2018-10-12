// copy_dx_dy_dz_waves.c
// copies header info from one MRC file to another
// 2018-01-30pmc

// 2018-10-12pmc: added ReverseFloat, ReverseShort functions to compensate for 
// hikari cluster's endianness-borking (changes ieee-le of .dv to ieee-be in .decon)

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* #include <sys/stat.h> */
/* #include <errno.h> */

short ReverseShort( const short inShort )
{
   short retVal;
   char *shortToConvert = ( char* ) & inShort;
   char *returnShort = ( char* ) & retVal;

   // swap the bytes into a temporary buffer
   returnShort[0] = shortToConvert[1];
   returnShort[1] = shortToConvert[0];
//   returnShort[2] = shortToConvert[1];
//   returnShort[3] = shortToConvert[0];

   return retVal;
}

float ReverseFloat( const float inFloat )
{
   float retVal;
   char *floatToConvert = ( char* ) & inFloat;
   char *returnFloat = ( char* ) & retVal;

   // swap the bytes into a temporary buffer
   returnFloat[0] = floatToConvert[3];
   returnFloat[1] = floatToConvert[2];
   returnFloat[2] = floatToConvert[1];
   returnFloat[3] = floatToConvert[0];

   return retVal;
}

int main(int argc, char** argv) {
  FILE *inf;
  FILE *outf;
  long dx_ofs=40; //  index for dx,type float
  long dy_ofs=44;
  long dz_ofs=48;
  long w1_ofs=198; //index for wave 1, type short
  long w2_ofs=200;
  long w3_ofs=202;
  long w4_ofs=204;
  long w5_ofs=206;
  float dx,dy,dz;
  short w1,w2,w3,w4,w5=0;
/*
 * char mode[]="0664";
 */
  if(argc==1) {
      printf("%s: please supply an input filename.\n",argv[0]);
      exit(1);
  }

  if(argc==2) {
      printf("%s: please supply an output filename.\n",argv[0]);
      exit(1);
  }


/*  if (chmod(argv[1],strtol(mode,0,8) < 0)) {
      fprintf(stderr,"%s: error in chmod(%s,%s) - %d (%s)\n",
              argv[0], argv[1], mode, errno, strerror(errno));
      exit(1);
  } */

  if (inf=fopen(argv[1],"r")) {
  fseek(inf,dx_ofs,SEEK_SET);
  fread(&dx,sizeof(float),1,inf);
  fread(&dy,sizeof(float),1,inf);
  fread(&dz,sizeof(float),1,inf);
  fseek(inf,w1_ofs,SEEK_SET);
  fread(&w1,sizeof(short),1,inf);
  fread(&w2,sizeof(short),1,inf);
  fread(&w3,sizeof(short),1,inf);
  fread(&w4,sizeof(short),1,inf);
  fread(&w5,sizeof(short),1,inf);
  fclose(inf);
  }
  else {
      fprintf(stderr,"%s: could not open input file %s.\n",argv[0],argv[1]);
      exit(1);
  }

  if(fabs(dx)>1) {
 //     printf("fabs(dx) is %.5f\n",fabs(dx));
      dx=ReverseFloat(dx);
      dy=ReverseFloat(dy);
      dz=ReverseFloat(dz);
      w1=ReverseShort(w1);
      w2=ReverseShort(w2);
      w3=ReverseShort(w3);
      w4=ReverseShort(w4);
      w5=ReverseShort(w5);
  }

  printf("Data: %f %f %f %i %i %i %i %i \n",dx,dy,dz,w1,w2,w3,w4,w5);
//  printf("Data-rev: %f %f %f %i %i %i %i %i \n",ReverseFloat(dx),ReverseFloat(dy),ReverseFloat(dz),ReverseShort(w1),w2,w3,w4,w5);

  if (outf=fopen(argv[2],"r+")) {
    fseek(outf,dx_ofs,SEEK_SET);
    fwrite(&dx,sizeof(float),1,outf);
    fwrite(&dy,sizeof(float),1,outf);
    fwrite(&dz,sizeof(float),1,outf);
    fseek(outf,w1_ofs,SEEK_SET);
    fwrite(&w1,sizeof(short),1,outf);
    fwrite(&w2,sizeof(short),1,outf);
    fwrite(&w3,sizeof(short),1,outf);
    fwrite(&w4,sizeof(short),1,outf);
    fwrite(&w5,sizeof(short),1,outf);
    fclose(outf);
  }
  else {
      fprintf(stderr,"%s: could not open output file %s.\n",argv[0],argv[2]);
      exit(1);
  }
return(0);
}

