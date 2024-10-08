#!/usr/bin/env perl
use v5.14;
use warnings;
use strict;
my $gff_file = shift or die "perl $0 ncbi_gff > new_gff\n";

open(F,$gff_file) || die "$!";

while(<F>){
    chomp;
    next if(/^#|^\s*$/);
    my @a = split/\t/;
    if($a[2] eq "mRNA"){
        $a[8] =~ /ID=rna-(\S+);Parent=gene-([^;]+)/;
        $a[8] = "ID=$1;gene=$2";
    }elsif($a[2] eq "CDS"){
        $a[8] =~ /Parent=(rna|id|gene)-([^;]+)/;
        die "$_\n" if(!$2);
        $a[8] = "Parent=$2";
    }else{
        next;
    }
    $a[1] = "refGene";
    print join "\t",@a,"\n";
}

close F;
