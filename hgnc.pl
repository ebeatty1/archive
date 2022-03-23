#!/usr/bin/perl
use strict; use warnings;
use Getopt::Long qw(GetOptions);
use File::Basename;
use lib dirname (__FILE__);
use hgnc;

my $version = '1.1';
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
                        Optional. The script will look to ./db/hgnc_complete_set.txt if not specified.
                            FILE=path of archive file
 -g (--gene-list) FILE  Use a plain text file containing gene identifiers. Identifiers can be OMIM #'s, HGNC-approved symbols or HGNC ID's.
                        Optional. Will use a defualt list if not specified.
                            FILE=path of list file
 -o (--omim-numbers)    Specifies that the list file contains OMIM numbers.
                        Optional. This is the default option if neither --omim or --symbols are specified.
 -n (--hgnc-ids)        Specifies that the list file contains HGNC ID's.
                        Optional. Not compatible with --omim.
 -p (--pseudogene)      Specifies that the list file contains pseudogene ID's.
                        Optional. Not compatible with --omim or --hgnc-ids.
 -e (--ensembl)         Specifies that the list file contains Ensembl gene ID's.
                        Optional. Not compatible with --omim, --hgnc-ids or --pseudogene.                                                                        
 -s (--symbols)         Specifies that the list file contains HGNC-approved symbols.
                        Optional. Not compatible with --omim, --hgnc-ids, --pseudogene or --ensembl.

END_USAGE

# getopt vars
my $help;
my $archiveFile = './db/hgnc_complete_set.txt';
my $geneListFile;
my $omimList;
my $hgncList;
my $symbolList;
my $ensemblList;
my $pgoList;

GetOptions(
	'h|help' =>         \$help,
    'a|archive=s' =>    \$archiveFile,
    'g|gene-list=s' =>  \$geneListFile,
    'o|omim-numbers' => \$omimList,
    'n|hgnc-ids' =>     \$hgncList,
    's|symbols' =>      \$symbolList,
    'e|ensembl' =>      \$ensemblList,
    'p|pseudogene' =>   \$pgoList
);

die $usage if $help;

# default gene list
my @geneList =  ('604094', '613932'); # MAD2L2, TNNI3K
# my @geneList =  ('HGNC:6764', 'HGNC:19661'); # MAD2L2, TNNI3K
# my @geneList =  ('PGOHUM00000296935', 'PGOHUM00000297088'); # CFTRP1, CFTRP2
# my @geneList =  ('ENSG00000001626', 'ENSG00000172817'); # CFTR, CYP7B1
# my @geneList =  ('XK', 'XRCC2', 'XYLT1'); # 314850, 600375, 608124

my %gene_obj_omim;
my %gene_obj_hgncid;
my %gene_obj_pgo;
my %gene_obj_ensembl;
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
    if ((defined($omimList)) || (!defined($omimList) && !defined($hgncList) && !defined($symbolList) && !defined($pgoList) && !defined($ensemblList))) 
    { 
        $gene_obj_omim{$gene_entry->get_omim_id()} = $gene_entry;
    }

    # else if using a list of hgnc ids
    elsif (defined($hgncList))
    { 
        $gene_obj_hgncid{$gene_entry->get_hgnc_id()} = $gene_entry; 
    }

    # else if using a list of pseudogene ids
    elsif (defined($pgoList))
    { 
        $gene_obj_pgo{$gene_entry->get_pseudogene_id()} = $gene_entry; 
    }

    # else if using a list of ensembl gene ids
    elsif (defined($ensemblList))
    { 
        $gene_obj_ensembl{$gene_entry->get_ensembl_gene_id()} = $gene_entry; 
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
        print   $gene_obj_omim{$omim}->get_prev_symbol()."\t".
                $gene_obj_omim{$omim}->get_alias_symbol()."\t".
                $gene_obj_omim{$omim}->get_symbol()."\t".
                $gene_obj_omim{$omim}->get_omim_id()."\t".
                $gene_obj_omim{$omim}->get_hgnc_id()."\t".
                $gene_obj_omim{$omim}->get_entrez_id()."\t".
                $gene_obj_omim{$omim}->get_ensembl_gene_id()."\t".
                $gene_obj_omim{$omim}->get_status()."\t".
                $gene_obj_omim{$omim}->get_name()."\t".
                $gene_obj_omim{$omim}->get_location()."\n"         
        if exists $gene_obj_omim{$omim};
    }
}

# elsif using a list of hgnc ids
elsif (%gene_obj_hgncid)
{
    foreach my $hgnc_id (@geneList)
    {
        print   $gene_obj_hgncid{$hgnc_id}->get_prev_symbol()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_alias_symbol()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_symbol()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_omim_id()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_hgnc_id()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_entrez_id()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_ensembl_gene_id()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_status()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_name()."\t".
                $gene_obj_hgncid{$hgnc_id}->get_location()."\n"          
        if exists $gene_obj_hgncid{$hgnc_id};
    }
}

# else if using a list of pseudogene ids
elsif (%gene_obj_pgo)
{
    foreach my $pseudogene_id (@geneList)
    {
        if (exists($gene_obj_pgo{$pseudogene_id}))
        {
            print   $gene_obj_pgo{$pseudogene_id}->get_symbol()."\t".
                    $gene_obj_pgo{$pseudogene_id}->get_pseudogene_id()."\n";
                    # $gene_obj_pgo{$pseudogene_id}->get_prev_symbol()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_alias_symbol()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_symbol()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_omim_id()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_hgnc_id()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_entrez_id()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_ensembl_gene_id()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_status()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_name()."\t".
                    # $gene_obj_pgo{$pseudogene_id}->get_location()."\n"             
        }
        else 
        {
            print "\t$pseudogene_id\tNo information on pseudogene in HGNC database.\n";
        }
    }
}

# else if using a list of ensembl gene ids
elsif (%gene_obj_ensembl)
{
    foreach my $ensembl_id (@geneList)
    {
        print   $gene_obj_ensembl{$ensembl_id}->get_prev_symbol()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_alias_symbol()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_symbol()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_omim_id()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_hgnc_id()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_entrez_id()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_ensembl_gene_id()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_status()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_name()."\t".
                $gene_obj_ensembl{$ensembl_id}->get_location()."\n"           
        if exists $gene_obj_ensembl{$ensembl_id};
    }
}

# else if using a list of symbols
elsif (%gene_obj_symbol)
{
    foreach my $symbol (@geneList)
    {
        print   $gene_obj_symbol{$symbol}->get_prev_symbol()."\t".
                $gene_obj_symbol{$symbol}->get_alias_symbol()."\t".
                $gene_obj_symbol{$symbol}->get_symbol()."\t".
                $gene_obj_symbol{$symbol}->get_omim_id()."\t".
                $gene_obj_symbol{$symbol}->get_hgnc_id()."\t".
                $gene_obj_symbol{$symbol}->get_entrez_id()."\t".
                $gene_obj_symbol{$symbol}->get_ensembl_gene_id()."\t".
                $gene_obj_symbol{$symbol}->get_status()."\t".
                $gene_obj_symbol{$symbol}->get_name()."\t".
                $gene_obj_symbol{$symbol}->get_location()."\n"     
        if exists $gene_obj_symbol{$symbol};
    }
}

else { print "PROBLEM ENCOUNTERED\n"; }