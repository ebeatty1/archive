#!/usr/bin/perl
use strict; use warnings;
use Getopt::Long qw(GetOptions);
use File::Basename;
use lib dirname (__FILE__);
use hgnc;

my $version = '1.0';
my $name = 'hgnc.pl';

my $usage = <<"END_USAGE";

NAME                    $name
VERSION                 $version
SYNOPSIS                Pulls data from the HGNC archive.
COMMAND                 $name
                        $name --gene-list list.txt -s
                        $name --archive archive.txt --gene-list list.txt -s 

OPTIONS:
 -h (--help)            Prints this message.
 -a (--archive) FILE    Tells the script which archive file to use.
                        Optional. The script will look for a file named hgnc_complete_set.txt in the current dir if not specified.
                            FILE=path of archive file
 -g (--gene-list) FILE  Use a plain text file containing gene identifiers. Identifiers can be either OMIM #'s or HGNC-approved symbols.
                        Optional. Will use a defualt list if not specified.
                            FILE=path of list file
 -o (--omim-numbers)    Specifies that the list file contains OMIM numbers.
                        Optional. This is the default option if neither --omim or --symbols are specified.
 -s (--symbols)         Specifies that the list file contains HGNC-approved symbols.
                        Optional. Not compatible with --omim.
 -p (--pseudogene)      Specifies that pseudogenes should be searched for.
                        Only works with -s.

END_USAGE

# getopt vars
my $help;
my $archiveFile = 'hgnc_complete_set.txt';
my $geneListFile;
my $omimList;
my $symbolList;
my $pseudogeneSearch;

GetOptions(
	'h|help' =>         \$help,
    'a|archive=s' =>    \$archiveFile,
    'g|gene-list=s' =>  \$geneListFile,
    'o|omim-numbers' => \$omimList,
    's|symbols' =>      \$symbolList,
    'p|pseudogene' =>   \$pseudogeneSearch
);

die $usage if $help;

# default gene list
my @geneList =  ('604094', '613932'); # MAD2L2, TNNI3K
# my @geneList =  ('XK', 'XRCC2', 'XYLT1'); # 314850, 600375, 608124
my %gene_obj_omim;
my %gene_obj_symbol;

# if -g
if ($geneListFile)
{
    open my $geneListIn, "<", "$geneListFile" or die "Can't open $geneListFile\n";
    @geneList = ();
    while (my $line = <$geneListIn>)
    {
        chomp($line);
        push(@geneList, $line); 
    }
    close $geneListIn;

    print "Using list from file\n";
}

# use default list
else { print "No list provided; using default: @geneList\n" }

# open the archive and process it
open my $archiveIn, "<", "$archiveFile" or die "Can't open $archiveFile\n";
while (my $line = <$archiveIn>)
{
    chomp($line);
    my $gene_entry = hgnc_gene->new($line);
    
    # if using a list of omim numbers
    if ((defined($omimList)) || (!defined($omimList) && !defined($symbolList))) 
    { 
        $gene_obj_omim{$gene_entry->get_omim_id()} = $gene_entry;
    }

    # else if using a list of symbols
    else { $gene_obj_symbol{$gene_entry->get_symbol()} = $gene_entry; }
}
close $archiveIn;

# if using a list of omim numbers
if (%gene_obj_omim)
{
    foreach my $omim (@geneList)
    {
        print   $gene_obj_omim{$omim}->get_omim_id()."\t".
                $gene_obj_omim{$omim}->get_pseudogene_id()."\t".
                $gene_obj_omim{$omim}->get_locus_group()."\t".
                $gene_obj_omim{$omim}->get_symbol()."\n"         
        if exists $gene_obj_omim{$omim};
    }
}

# else if using a list of symbols
elsif (%gene_obj_symbol)
{
    foreach my $symbol (@geneList)
    {
        print   $gene_obj_symbol{$symbol}->get_omim_id()."\t".
                $gene_obj_symbol{$symbol}->get_locus_group()."\t".
                $gene_obj_symbol{$symbol}->get_symbol()."\t".
                $gene_obj_symbol{$symbol}->get_ensembl_gene_id()."\t".  
                $gene_obj_symbol{$symbol}->get_pseudogene_id()."\n"
        if exists $gene_obj_symbol{$symbol};

        # if -p, search for pseudogenes
        if (defined($pseudogeneSearch))
        {
            for (my $i = 1; $i < 100; $i++)
            {
                my $pseudoSymbol = $symbol."P".$i;
                print   $gene_obj_symbol{$pseudoSymbol}->get_omim_id()."\t".
                        $gene_obj_symbol{$pseudoSymbol}->get_locus_group()."\t".
                        $gene_obj_symbol{$pseudoSymbol}->get_symbol()."\t".
                        $gene_obj_symbol{$pseudoSymbol}->get_ensembl_gene_id()."\t".      
                        $gene_obj_symbol{$pseudoSymbol}->get_pseudogene_id()."\n"
                if exists $gene_obj_symbol{$pseudoSymbol};
            }
        }
    }
}