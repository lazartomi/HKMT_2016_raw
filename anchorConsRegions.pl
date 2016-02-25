#
#

use Data::Dump;
use Set::IntSpan;

$name=shift(@ARGV);
$consTreshold=shift(@ARGV);
$minlength=shift(@ARGV);

open (IN, $name.".anchor");
$count=0;
while(<IN>){
    chomp;
    $_ =~ s/\s+/ /;
    if($_ =~ /<td width=\"25\%\" align=\"right\"/) {
        $str = substr($_,30,6);
        $to = index($str, "&");
        $str = substr($str,0,$to);
        if($count % 3 == 0) {
            push(@start,$str);
        }elsif ($count % 3 == 1) {
            push(@end,$str);
        }
        $count++;
    }
    
}
close IN;
#dd @end;
#print "\n";

open(CONS, $name.".cons");
while(<CONS>){
    chomp;
    @array=split(/\s+/, $_);
    if(substr($array[2],0,1) ne "-"){
        push(@cons,$array[0]);
    }
}
close CONS;

#$k=1;
#foreach $i (@cons){
#    print $k . ".: " . $i."\n";
#    $k++;
#}

for($i=0; $i<scalar(@cons); $i++) {
    for($j=0; $j<scalar(@start); $j++){
        if($start[$j] <= $i && $end[$j] >= $i && $cons[$i] >= $consTreshold) {
            push(@consBinding,$i);
        }
    }
}

$set = Set::IntSpan->new(@consBinding);

@spans = $set->spans;

for($i=0; $i<scalar(@spans); $i++){
    if($spans[$i][1] - $spans[$i][0] > ($minlength-2) ){
        print $spans[$i][0]."-".$spans[$i][1].", ";
    }
}

print "\n";