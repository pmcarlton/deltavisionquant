#!/usr/bin/perl
 
#input: an mrc file with N wavelengths, and a reference shift file
#output: an mrc file whose data are Z-shifted by X1,X2...Xn pixels
#using IVE utilities Flip, Resample2D, Flip, Reverse
#20130129pmc

@dtypes=('Byte(uchar)','Short(int16)','Float(float32)','Short(int16)','Float/(float32)','Short/(int16)','UShort/(uint16)','Long/(int32)');

$finname=shift;
$inname=qx(basename $finname);
chomp($inname);

$zshiftfile="/tmp/alp";
#$rmflag=shift;
$rmflag=1;

$outname=$inname.".zs";

#$outname="/tmp/".$inname.".zs";

open IN,$finname or die "Couldn't find $finname !";

$br=read(IN,$hdr,1024);
close IN;

if($br != 1024){die "jacked!!!";}

$endi = "undefined";
($ncol, $nrow, $nsecs, $pixtype, $mxst, $myst, $mzst, $mx, $my, $mz,
  $dx,$dy,$dz,$alpha,$beta,$gamma,$colax,$rowax,$secax,$min,$max,$mean,
  $nspg, $next, $dvid, $nblank, $ntst, $blank, $numints, $numfloats, $sub,
  $zfac, $min2, $max2, $min3, $max3, $min4, $max4, $imtype, $lensnum,
  $n1, $n2, $v1, $v2, $min5, $max5, $ntimes, $imgseq, $xtilt, $ytilt, $ztilt,
  $nwaves, $wv1, $wv2, $wv3, $wv4, $wv5, $z0, $x0, $y0, $ntitles,
  $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $t10) = unpack (
  "l>l>l>l>l>l>l>l>l>l>f>f>f>f>f>f>l>l>l>f>f>f>l>l>s>s>l>A24s>s>s>s>f>f>f>f>f>f>s>s>s>s>s>s>f>f>s>s>f>f>f>s>s>s>s>s>s>f>f>f>l>A80A80A80A80A80A80A80A80A80A80",$hdr);

if($pixtype >=0 && $pixtype<7) {$endi="ieee-be";}

else {
#    print ("trying little-endian...");
($ncol, $nrow, $nsecs, $pixtype, $mxst, $myst, $mzst, $mx, $my, $mz,
  $dx,$dy,$dz,$alpha,$beta,$gamma,$colax,$rowax,$secax,$min,$max,$mean,
  $nspg, $next, $dvid, $nblank, $ntst, $blank, $numints, $numfloats, $sub,
  $zfac, $min2, $max2, $min3, $max3, $min4, $max4, $imtype, $lensnum,
  $n1, $n2, $v1, $v2, $min5, $max5, $ntimes, $imgseq, $xtilt, $ytilt, $ztilt,
  $nwaves, $wv1, $wv2, $wv3, $wv4, $wv5, $z0, $x0, $y0, $ntitles,
  $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $t10) = unpack (
  "l<l<l<l<l<l<l<l<l<l<f<f<f<f<f<f<l<l<l<f<f<f<l<l<s<s<l<A24s<s<s<s<f<f<f<f<f<f<s<s<s<s<s<s<f<f<s<s<f<f<f<s<s<s<s<s<s<f<f<f<l<A80A80A80A80A80A80A80A80A80A80",$hdr);
if($pixtype >=0 && $pixtype<7) {$endi="ieee-le";}
else {die ("failed: pixtype is $pixtype, and endian is $endi")};
}

print "#Read success: pixtype is $dtypes[$pixtype], endian is $endi\n";

$doshift=0;$nshifts=0;
open IN,$zshiftfile;
@zs=(<IN>);close IN;
foreach $line (@zs) {
@zline=split(" ",$line);
if ($zline[0] == $wv1){$doshift+=1; $sh[0]=$zline[1];$shwv[0]=$zline[0];$nshifts++;}
if ($zline[0] == $wv2){$doshift+=2; $sh[1]=$zline[1];$shwv[1]=$zline[0];$nshifts++;}
if ($zline[0] == $wv3){$doshift+=4; $sh[2]=$zline[1];$shwv[2]=$zline[0];$nshifts++;}
if ($zline[0] == $wv4){$doshift+=8; $sh[3]=$zline[1];$shwv[3]=$zline[0];$nshifts++;}
if ($zline[0] == $wv5){$doshift+=16; $sh[4]=$zline[1];$shwv[4]=$zline[0];$nshifts++;}
}

if ($doshift==0) {die ("Not shifting file $inname, no wavelengths matched the shifts file.\n");}

for $i(0..$nshifts-1) {
    print("Flip $finname /tmp/$inname.w$shwv[$i].flip -w1=$i -xz");
    print("\n");
    print("Resample2D /tmp/$inname.w$shwv[$i].flip /tmp/$inname.w$shwv[$i].rs2 -shift=0.0:$sh[$i]");
    print("\n");
    print("Flip /tmp/$inname.w$shwv[$i].rs2 /tmp/$inname.w$shwv[$i].unflip -xz");
    print("\n");
}
    print("mergemrc -append_waves $outname /tmp/$inname.w???.unflip");
    #print("mergemrc -mode=unsigned16 -append_waves $outname /tmp/$inname.w???.unflip");
    if($rmflag) {print "\nrm /tmp/$inname.w*";}
    print("\n");
