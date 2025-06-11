#!/usr/bin/env perl
use warnings;
use strict;

my ($seq_dir,$type,$gap_ratio)= @ARGV;
die "Usage:\nperl $0  <seq_dir(XXX.fa)>  <type(gene or 4dTV)>  <max gap ratio(recommend: 0.2)>\n" if(@ARGV<3);
if($type =~ /gene/i){
    mkdir "align" if(!-e "align");
}elsif($type =~ /4dTV/i){
    mkdir "genes_filter" if(!-e "genes_filter");
}else{
    die "Undefined type: $type!\n";
}
my @seq_file = <$seq_dir/*fa>;
for my $seq_file(@seq_file){
    $seq_file =~ /$seq_dir\/(\S+)\.fa/;
    my $name = $1;
    my %seq = &read_seq($seq_file);
    my $judge = 1;
    for my $id(sort keys %seq){
        my $gap_num = $seq{$id} =~ s/-/-/g;
        my $len = length($seq{$id});
        my $ratio = $gap_num / $len;
        $judge = 0 if($ratio > $gap_ratio);
    }
    if($judge){
        if($type =~ /gene/i){
		# `mkdir -p align/$name`;
            open(O,">align/$name.fas");
            print O ">$_\n$seq{$_}\n" for(sort keys %seq);
            close O;
        }elsif($type =~ /4dTV/i){
            open(O,">genes_filter/$name.fa");
            print O ">$_\n$seq{$_}\n" for(sort keys %seq);
            close O;
        }
    }
}

sub read_seq{
    my $file = shift;
    my %hash; my $id;
    for(`cat $file`){
        chomp;
        if(/^>/){
            $_ =~ /^>(\S+)/;
            $id = $1;
        }else{
            s/\s+//g;
            $hash{$id} .= $_;
        }
    }
    return %hash;
}
