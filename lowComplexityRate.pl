#
#

$list=shift(@ARGV);
$count=1;
open(IN, $list);
@array=();
while(<IN>){
    chomp;
    if ($count%100 == 0) {
        print $count. "; ";
    }
    $count++;
    $try = qx/du -h $_.fasta/;
    if (substr($try,0,4) eq "  0B" || substr($try, length($try)-9,9) eq "directory") {
        $link = "www.uniprot.org/uniprot/" . $_ . ".fasta";
        system("curl -s $link > $_.fasta");
    }
    
    $temp = qx/du -h $_.seg/;
    if (substr($temp,0,4) eq "  0B" || substr($try, length($try)-9,9) eq "directory") {
        system("segmasker -in $_.fasta -outfmt fasta -out $_.seg");
    }
    open(SEG, $_.".seg");
    $uppercase=0;
    $lowercase=0;
    while (<SEG>) {
        if (!/^>/) {
            chomp;
            for($i=0; $i<length($_); $i++){
                if (substr($_,$i,1) eq uc(substr($_,$i,1))) {
                    $uppercase++;
                }else{
                    $lowercase++;
                }
            }
        }
    }
    if ($lowercase==0){
        push(@array, 0);
    }else{
        push(@array,($lowercase/($uppercase+$lowercase)));
    }
    close SEG;
}
$sum=0;
foreach $k (@array){
    #print $k . "; ";
    $sum+=$k;
}
print "\n";
$mean=$sum/scalar(@array);
print "The mean low complexity of the group: m = " . $mean . "\n";
$sumdiff2=0;
foreach $k (@array){
    $sumdiff2+=(($k-$mean)**2);
}
$SD=sqrt((1/scalar(@array))*$sumdiff2);
print "SD = " . $SD . "\n";
print "N = " . scalar(@array) . "\n";
close IN;