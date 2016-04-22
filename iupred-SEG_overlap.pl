#
#
use strict;
use warnings;

my $list = shift(@ARGV);
my @LC=();
my @LCID=();
my @GB=();
my @ID=();
my @DS=();
my @L=();
open(IN, $list);
my $line1="";
my $L=0; my $B=0; my $G=0; my $I=0;
while (<IN>) {
    chomp;
    #print "<$_.iupred>\n";
    $line1 = $_;
    #my $command = "./iupred  ../SwissProtHuman/$line1.seg  long  > ../SwissProtHuman/$line1.iupred";
    #qx/$command/;
    $L=0; $B=0; $G=0; $I=0;
    my $path = "../$line1.iupred";
    open(IUP, $path);
    my $line2="";
    while (<IUP>) {
        if (!/^#/) {
            chomp;
            $line2 = $_;
            my $aa = substr($line2, 6, 1);
            my $score = substr($line2, 12, 6);
            unless ( $score =~ /^[0-9.]+$/ ) {
                print "score is not a number in $path which is the " . scalar(@LC). "th protein\n";
                exit;
            }
            #print "$aa $score\n";
            if ($aa eq lc($aa)) {
                if ($score < 0.5) {
                    $L++;
                }else{
                    $B++;
                }
            }else{
                if ($score < 0.5) {
                    $G++;
                }else{
                    $I++;
                }
            }
        }
    }
    close IUP;
    
    push(@LC, ($L/($L+$B+$G+$I)));
    push(@LCID, ($B/($L+$B+$G+$I)));
    push(@GB, ($G/($L+$B+$G+$I)));
    push(@ID, ($I/($L+$B+$G+$I)));
    push(@DS, (($B+$I)/($L+$B+$G+$I)));
    push(@L, (($B+$L)/($L+$B+$G+$I)));
}
close IN;

print "Low complexity stat:\n";
descr_stat(\@LC);
print "Low complexity disorder stat:\n";
descr_stat(\@LCID);
print "Non-LC globular stat:\n";
descr_stat(\@GB);
print "Non-LC disorder stat:\n";
descr_stat(\@ID);

print "\nProportion of disordered AAs: ";
descr_stat(\@DS);
print "\nProportion of LC AAs: ";
descr_stat(\@L);

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
