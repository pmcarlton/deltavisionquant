$fname = shift;
$ntries = shift;

open IN, $fname; @a = (<IN>); close $fname;

$badflag = 0;
foreach $line (@a) {
  if ($line =~ /cycle\s/) { 
      $b++; 
      if ($ncyc % 15) {$badflag = 1;
      print "\nSo ncyc is $ncyc and I think that $ncyc mod 15 is not zero! Am I crazy?\n"}
  }

  if ($b) {
      if ($line =~ /nan/i) { $badflag = 1; }
      else {
	  @tst = split (" ", $line);
	  if ($#tst==3) {
          $ncyc=$tst[0];
	      for $i (1..$#tst) {
		      if ($tst[$i] > 2) {$badflag = 1;}
		      if ($tst[$i] < 0) {$badflag = 1;}
		      }
		  }
	  }
  }
}

if($badflag) { $ntries += $badflag; print ($ntries); }
else {print 42;}
