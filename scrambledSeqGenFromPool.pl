#
#
use List::Util qw(shuffle);

$infile = shift(@ARGV);
$limit = shift(@ARGV);

open(IN, $infile);
while (<IN>) {
    chomp;
    $filename=$_.".fasta";
    $link = "www.uniprot.org/uniprot/" . $filename;
    $unp = qx/curl -s $link/;
    qx/curl -s $link > $filename/;
    @fasta = split(/\n/,$unp);
    for($j=1; $j<scalar(@fasta); $j++){
        $seq .= $fasta[$j];
    }
}
for($k=0; $k<length($seq) ; $k++){
    push(@array, substr($seq,$k,1));
}

for($i=1; $i<21; $i++){
    @array2 = shuffle(@array);
    print ">scrambled_seq$i\n";
    for($k=0; $k<$limit ; $k++){
        print $array2[$k];
    }
    print "\n";
}