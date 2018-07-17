// mkMRCtime0 : use on Carlton lab Deltavision files.
// changes bytes 101-104 of the MRC header to 0,
// making sure the starting time is 0 (was causing problems with decon on hikari cluster, when it was set higher FOR SOME UNKNOWN REASON)
// 2013-06-11pmc

#include <stdio.h>

int main(int argc, char** argv) {
  FILE *fd;
  const long ofs=100; // changing byte 100
  const long signed int data=0;  // we want to write a zero

  if(argc==1) {
      printf("%s: please supply a filename.\n",argv[0]);
      exit(1);
  }

  if (fd=fopen(argv[1],"r+")) {
  fseek(fd,ofs,SEEK_SET);
  fwrite(&data,sizeof(long signed int),1,fd);
  fclose(fd);
  return(0);
  }
  else {
      printf("%s: could not open %s.\n",argv[0],argv[1]);
      exit(1);
  }
}

