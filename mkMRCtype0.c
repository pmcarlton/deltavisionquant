// mkMRCtype0 : use on Carlton lab Deltavision files.
// changes bytes 160-161 of the MRC header to 0,
// making the extended header readable by Priism
// 2013-04-09pmc

#include <stdio.h>
/* #include <sys/stat.h> */
/* #include <stdlib.h> */
/* #include <errno.h> */

int main(int argc, char** argv) {
  FILE *fd;
  const long ofs=160; // changing byte 160
  const short data=0;  // we want to write a zero
/*
 * char mode[]="0664";
 */
  if(argc==1) {
      printf("%s: please supply a filename.\n",argv[0]);
      exit(1);
  }

/*  if (chmod(argv[1],strtol(mode,0,8) < 0)) {
      fprintf(stderr,"%s: error in chmod(%s,%s) - %d (%s)\n",
              argv[0], argv[1], mode, errno, strerror(errno));
      exit(1);
  } */

  if (fd=fopen(argv[1],"r+")) {
  fseek(fd,ofs,SEEK_SET);
  fwrite(&data,sizeof(short),1,fd);
  fclose(fd);
  return(0);
  }
  else {
      fprintf(stderr,"%s: could not open %s.\n",argv[0],argv[1]);
      exit(1);
  }
}

