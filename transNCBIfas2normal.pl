use warnings;
use strict;

my $file = shift or die "Usage: perl $0  <seq file> <species name>  <prefix: Default:Chr, or custome>  > output\n";
my $sp = shift;
my $prefix = shift;
$prefix = "Chr" if(!$prefix);
#my %seq; 
my $id;
open(O,">$sp.transname.list");
for(`cat $file`){
    chomp;
    if(/^>NC_/){
        my $j = 0;
        $_ =~ /^>(\S+)\s+.+chromosome\s+(\S+)\s+/;
        my $old = $1;
        unless($_ =~ /scaffold/){
            if($2){
                $_ =~ /^>(\S+)\s+.+chromosome\s+(\S+)\s+/;
                $id = $prefix.$2;
                $id =~ s/,//;
                print O "$old\t$id\n";
                $j = 1;
            }
        }#else{
         #   $_ =~ /^>(\S+)\s+.+scaffold_(\d+)/;
         #   $id = "UnChr$2";
         #   print O "$1\t$id\n";
        #}
        print ">$id\n" if($j == 1);
        print "$_\n" if($j == 0);
    }else{
        print $_,"\n"
    }
}
close O;
