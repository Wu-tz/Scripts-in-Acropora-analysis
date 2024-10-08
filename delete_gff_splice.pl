#!/usr/bin/env perl
use v5.14;
use warnings;
use strict;

my ($ncbi_gff,$list) = @ARGV;
die "Usage:\nperl  $0  ncbi_gff  trans_list  > new_gff\n" if(@ARGV<2);
my %trans_name;
for(`cat $list`){
    chomp;
    $_ =~ /^(\S+)\s+(\S+)$/;
    $trans_name{$1} = $2;
}

my %hash; my %master; my %len; my %judge;
my $gene; my $lable = 0;
open(F,$ncbi_gff) or die $!;
while(<F>){
    chomp;
    next if(/^#|^\s*$/);
    my @a = split/\t+/;
    #print STDERR "$a[1]\t$a[2]\t$a[3]\n" if($a[2] !~ /gene|mRNA|CDS|exon|transcript/);
    $a[0] = $trans_name{$a[0]} if(exists $trans_name{$a[0]});
    if($a[2] eq "gene"){
        $lable++;
        $a[8] =~ /ID=([^;]+)/;
        $gene=$1; $gene =~ s/gene-//;
        if(exists $judge{$gene}){
            $master{$gene}++;
            $gene .= "#".$master{$gene};
            print STDERR $gene,"\n";
        }
        #print STDERR $gene,"\n";
        $hash{$lable}{$gene}{gene} = join "\t",@a;
        $judge{$gene}++;
    }elsif($a[2] eq "mRNA"){
        $a[8] =~ /ID=([^;]+)/;
        my $rna = $1; $rna =~ s/rna-//;
        push(@{$hash{$lable}{$gene}{$rna}},join "\t",@a);
        $len{$lable}{$gene}{$rna} = 0;
    }elsif($a[2] eq "CDS"){
        $a[8] =~ /Parent=([^;]+)/;
        my $rna = $1;
        die "$_\n" if(!$1);
        $rna =~ s/rna-//;
        push(@{$hash{$lable}{$gene}{$rna}},join "\t",@a);
        $len{$lable}{$gene}{$rna} += $a[4]-$a[3]+1;
    }
}
close F;
print STDERR "The gene sum number is: ",scalar (keys %hash),"\n";
my %j;
for my $n(sort {$a<=>$b} keys %hash){
    for my $name(keys %{$hash{$n}}){
        #print STDERR "$name\t$max\n";
        my $j = 0; my $out = "NA";
        for my $rna (keys %{$hash{$n}{$name}}){
            next if($rna eq "gene");
            if($j < $len{$n}{$name}{$rna}){
                $j = $len{$n}{$name}{$rna};
                $out = $hash{$n}{$name}{gene}."\n";
                my $other = join "\n",@{$hash{$n}{$name}{$rna}};
                $out .= $other."\n";
            }
        }
        if($out eq "NA"){
            print STDERR "Check the gene: $name.\n";
        }else{
            print $out;
        }
    }
}

