#
#

use strict;
#use warnings;

open(IDS, "DisoRepresentative_HKMT_IDs.txt") or die "Couldn't open the ID mapping file\n";
while (<IDS>) {
    chomp;
    my $uniprotID = "";
    my $name = "";
    ($uniprotID, $name) = split(/\s+/, $_);
    open(ALIGN, $name."_vertebrata.fasta") or die "Couldn't open the $name alignment file\n";
    my $temp = 0;
    my $seq = "";
    while (<ALIGN>) {
        chomp;
        if (/^>/) {
            if (substr($_,1,6) eq $uniprotID) {
                $temp++;
            }
        }else{
            if ($temp == 1) {
                $seq .= $_;
            }elsif($temp > 1) {
                last;
            }
        }
    }
    #print $name . " " . substr($seq,0,170) . "\n\n";
    close ALIGN;
    open(ELM, $name.".elm") or die "Couldn't open $name.elm file\n";
    my @elmStart = ();
    my @elmEnd = ();
    my @elmRows = ();
    while (<ELM>) {
        chomp;
        (my $start, my $end, my $elm, my $type, my $exp) = split(/\s+/, $_);
        push (@elmRows, $_);
        push(@elmStart, $start);
        push(@elmEnd, $end);
    }
    close ELM;
    
    open(CONS, $name.".cons") or die "Couldn't open $name.cons file\n";
    my @consLines = ();
    while (<CONS>) {
        chomp;
        push(@consLines, $_);
    }
    close CONS;
    my @consScores = ();
    my @elmConsScores = ();
    my $count = 0;
    for(my $i=0; $i<length($seq); $i++){
        if (substr($seq,$i,1) ne "-") {
            $count++;
            my $score = substr($consLines[$i],0,5);
            if(length($score) > 3){
                if($score >= 0.0){
                    push(@consScores, $score);
                    #print $score . "\n";
                }
            }
            for(my $j=0; $j<scalar(@elmStart); $j++){
                if ($count >= $elmStart[$j] && $count <= $elmEnd[$j]) {
                    my $elmConsScore = substr($consLines[$i],0,5);
                    if(length($elmConsScore) > 3){
                        if($elmConsScore >= 0.0){
                            push(@elmConsScores,$elmConsScore);
                        }
                    }
                }
                
            }
        }
    }
    print "$name: conservation:\n";
    if (scalar(@consScores) == 0) {
        print $name . " consScores array is empty!\n";
        exit;
    }else{
        descr_stat(\@consScores);
    }
    
    print "ELMs of $name: conservation:\n";
    if (scalar(@elmConsScores) == 0) {
        print $name . " elmConsScores array is empty!\n\n";
        if($name ne "SUV420H1"){
            exit;
        }
    }else{
        open(OUT, ">", $name.".elmcons");
        
        my $prevEnd=0;
        for(my $k=0; $k<scalar(@elmRows); $k++){
            (my $start, my $end, my $elm, my $type, my $exp) = split(/\s+/, $elmRows[$k]);
            my $length = $end-$start+1;
            my $sumScore=0;
            for(my $s=$prevEnd; $s<($prevEnd+$length); $s++){
                $sumScore += $elmConsScores[$s];
                #print $sumScore ."\n";
            }
            my $avgScore = 0;
            $avgScore = $sumScore / $length;
            $prevEnd += $length;
            print OUT $elmRows[$k]. " ". $avgScore."\n";
        }
        close OUT;
        
        descr_stat(\@elmConsScores);
        print "\n";
    }
}


sub descr_stat{
    my $numbersref = shift;
    my @numbers = @{$numbersref};
    my $sum=0;
    foreach my $n (@numbers){
        $sum+=$n;
    }
    my $N=scalar(@numbers);
    my $avg=$sum/$N;
    my $diff2=0;
    foreach my $n (@numbers){
        $diff2 += ($n-$avg)**2;
    }
    my $sd = sqrt((1/$N)*$diff2);
    
    print "m=". $avg . "; s=". $sd . "; N=" . $N . "\n";
}