The files contained within this directory include sequence alignment files, codes, and related scripts utilized in the article entitled "Ancient hybridization fueled diversification in Acropora corals." Specific comments regarding each file are provided below.

a) Gene_alignments_of_acropora.zip: This zip file contains 7756 nuclear protein coding sequences obtained by genomic colinearity analysis.

b) scripts+controlfiles_of_acropora_analysis.txt: This file contains all the codes used in the analysis of the article, as well as the control file content used in the dn/ds analysis.

c) transNCBIfas2normal.pl: This Perl script is used to format and rename the names of chromosomes in the reference genome.

d) delete_gff_splice.pl: This Perl script is used to format and rename the chromosome names of the GFF file of the reference genome.

e) simplify_gff.pl: This Perl script is used to simplify the GFF file, keeping only the lines annotated with "CDS" and "mRNA."

f) 04.4Dsites.pl: This Perl script is used to extract the fourfold degenerate sites of protein coding sequences.

g) catfasta2phyml.pl: This Perl script is used to concatenate sequences in FASTA format for subsequent concatenation to construct a phylogenetic tree.

h) new_lastz.pl: This Perl script is the main process for genome collinearity alignment using Lastz software.

i) tree_cluster.R: This R script uses the Multidimensional Scaling algorithm to analyze gene tree topological heterogeneity.
